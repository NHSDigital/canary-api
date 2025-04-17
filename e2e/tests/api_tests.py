from os import getenv
from time import sleep

import pytest
import requests


@pytest.mark.smoketest
def test_wait_for_ping(nhsd_apim_proxy_url):
    retries = 0
    resp = requests.get(f"{nhsd_apim_proxy_url}/_ping", timeout=30)
    deployed_commit_id = resp.json().get("commitId")

    while deployed_commit_id != getenv("SOURCE_COMMIT_ID") and retries <= 30:
        resp = requests.get(f"{nhsd_apim_proxy_url}/_ping", timeout=30)

        if resp.status_code != 200:
            pytest.fail(f"Status code {resp.status_code}, expecting 200")

        deployed_commit_id = resp.json().get("commitId")
        retries += 1
        sleep(1)

    if retries >= 30:
        pytest.fail("Timeout Error - max retries")

    assert deployed_commit_id == getenv("SOURCE_COMMIT_ID")


@pytest.mark.smoketest
def test_check_status_is_secured(nhsd_apim_proxy_url):
    resp = requests.get(f"{nhsd_apim_proxy_url}/_status")
    assert resp.status_code == 401


@pytest.mark.smoketest
@pytest.mark.parametrize("service_header", ["", "another-service"])
def test_wait_for_status(nhsd_apim_proxy_url, status_endpoint_auth_headers, service_header):
    retries = 0
    headers = status_endpoint_auth_headers
    if service_header:
        headers["x-apim-service"] = service_header
    resp = requests.get(
        f"{nhsd_apim_proxy_url}/_status", headers=headers, timeout=30
    )

    if resp.status_code != 200:
        # Status should always be 200 we don't need to wait for it
        pytest.fail(f"Status code {resp.status_code}, expecting 200")
    version_info = resp.json().get('_version')
    if not version_info:
        pytest.fail("_version not found")

    deployed_commit_id = version_info.get("commitId")

    while deployed_commit_id != getenv("SOURCE_COMMIT_ID") and retries <= 50:
        resp = requests.get(
            f"{nhsd_apim_proxy_url}/_status", headers=status_endpoint_auth_headers, timeout=30
        )

        deployed_commit_id = resp.json().get('_version', {}).get("commitId")
        retries += 1
        sleep(2)

    if retries >= 50:
        pytest.fail("Timeout Error - max retries")

    assert resp.status_code == 200
    assert deployed_commit_id == getenv("SOURCE_COMMIT_ID")
    body = resp.json()
    assert body.get("status") == "pass"
    assert body.get("service") == 'canary'

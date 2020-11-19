#!/usr/bin/env python3
import json
try:
    import cfscrape
except ModuleNotFoundError:
    print(json.dumps({"local_blocknumber": -1, "ethscan_blocknumber": -100}))
    exit(0)
import requests
import sys

usage = """
Usage:
    check-geth-sync.py <etherscanApiUrl> <etherscanApiToken> <localGethUrl>

where:
    etherscanApiUrl is an URL to etherscan
    etherscanApiToken is a token got from etherscan.io
    localGethUrl is an URL to local geth instance like http://localhost:9656
"""

if len(sys.argv) < 3:
    print(usage)
    sys.exit(2)

# Getting local block number
local_geth_url = sys.argv[3]
payload = '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
headers = {'Content-Type': 'application/json'}
r = requests.post(local_geth_url, data=payload, headers=headers)
local_bnum = int(r.json()['result'], 16)

# Getting remote block number
remote_host = sys.argv[1]
api_token = sys.argv[2]
ethscan_url = 'https://{remote_host}/api?module=proxy&action=eth_blockNumber&apikey={api_token}'.format(  # noqa
        remote_host=remote_host,
        api_token=api_token)

scraper = cfscrape.create_scraper()  # returns a CloudflareScraper instance
rez = scraper.get(ethscan_url).content

ethscan_bnum = int(json.loads(rez.decode('utf-8'))['result'], 16)

print(json.dumps({"local_blocknumber": local_bnum, "ethscan_blocknumber": ethscan_bnum}))

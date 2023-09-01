import base64

data = """
{
  "auths": {
    "https://index.docker.io": {
      "access_token": "dckr_pat_QzUlbVKTAECsqOK3LwPZ0ceAO98"
    }
  }
}
"""

encoded_data = base64.b64encode(data.encode())

print(encoded_data.decode())

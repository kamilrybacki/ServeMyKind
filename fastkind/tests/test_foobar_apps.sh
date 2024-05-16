#!/bin/bash

MANIFEST_URL=/home/kamil/Projekty/Moje/operations/ansible/k8s/k8s-kind-nginx-ingress/tests/test_services.yaml

echo "Creating the ingress"
kubectl \
  apply \
    -f \
      $MANIFEST_URL

echo "Waiting for the ingress to be ready"
kubectl \
  wait \
    --for=condition=ready \
    pod \
      --all \
      --timeout=300s

echo "Testing the foo app"
FOO_HOSTNAME=$(curl -X GET "localhost/foo/hostname")
echo "Foo app response:"
echo "$FOO_HOSTNAME"
if [ "$FOO_HOSTNAME" != "foo-app" ]; then
  echo "Foo app failed"
  STATUS=1
fi

echo "Testing the bar app"
BAR_HOSTNAME=$(curl -X GET "localhost/bar/hostname")
echo "Bar app response:\n"
echo "$BAR_HOSTNAME"
if [ "$BAR_HOSTNAME" != "bar-app" ]; then
  echo "Bar app failed"
  STATUS=1
fi

echo "Cleaning up"
kubectl \
  delete \
    -f \
      $MANIFEST_URL

if [ "$STATUS" -eq 0 ]; then
  echo "All tests passed"
else
  echo "Some tests failed"
fi
exit "$STATUS"

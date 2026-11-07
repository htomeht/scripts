#!/bin/bash

replicas=(101 102 103)
endpoints=(101 102 103 104 105 106)

contains () { [[ "$1" =~ (^|[[:space:]])"$2"($|[[:space:]]) ]]; }

for endpoint in "${endpoints[@]}"; do
  echo "Looking at $endpoint"
  contains "${replicas[*]}" "$endpoint" && echo "yes" || echo "no"
done

#!/usr/bin/env bash

# Get the old and new module paths from arguments
OLD_MODULE=$1
NEW_MODULE=$2

# Update go.mod with the new module name
sed -i "s|$OLD_MODULE|$NEW_MODULE|g" go.mod

# Replace module name in all Go source files
sed -i "s|$OLD_MODULE|$NEW_MODULE|g" $(find . -type f -name '*.go')

# Run go mod tidy to update dependencies
go mod tidy

echo "Module name changed from $OLD_MODULE to $NEW_MODULE"


#!/bin/bash


file=$1
class=$(basename "$file" .java )


javac "$file" && java "$class"

package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func Test_getHowdyMessage(t *testing.T) {
	assert.Equal(t, "Howdy!", GetHowdyMessage(), "should be equal")

}

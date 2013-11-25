package ast

import (
	"bytes"
	"fmt"
)

// Exit represents a statement stops the query on the current object.
type Exit struct {
}

func (e *Exit) node() string {}

// NewExit creates a new Exit instance.
func NewExit() *Exit {
	return &Exit{}
}

// Converts the statement to a string-based representation.
func (e *Exit) String() string {
	return "EXIT"
}

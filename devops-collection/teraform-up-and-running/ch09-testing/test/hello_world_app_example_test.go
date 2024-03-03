package test

import (
	"fmt"
	"strings"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"

	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestHelloWorldAppExample(t *testing.T) {

	t.Parallel()

	opts := &terraform.Options{
		// You should update this relative path to point at your
		// hello-world-app example directory!
		TerraformDir: "../examples/hello-world-app/standalone",

		// This code is passing in some mock data for the mysql_config variable.
		// Alternatively, you could set this value to anything you want: for example, you could
		// fire up a small, in-memory database at test time and set the address to that database’s IP.
		Vars: map[string]interface{}{
			"mysql_config": map[string]interface{}{
				"address": "mock-value-for-test",
				"port":    3306,
			},
			"environment": fmt.Sprintf("test-%s", random.UniqueId()),
		},
	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	// Instead of using http_helper.HttpGetWithRetry to check for a 404 response,
	// the test is using the http_helper.HttpGetWithRetryWithCustomValidation
	// method to check for a 200 response and a body that contains the text “Hello, World.”
	// That’s because the User Data script of the hello-world-app module returns a 200 OK
	// response that includes not only the server text but also other text, including HTML.
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, "Hello, World")
		},
	)

}

mock "tfplan/v2" {
    module {
        source = "../testdata/non-compliant/mock-ec2-missing-imds.sentinel"
    }
}

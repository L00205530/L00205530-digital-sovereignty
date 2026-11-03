policy "digital-sovereignty" {
    source            = "./digital-sovereignty.sentinel"
    enforcement_level = "hard-mandatory"
}

mock "tfplan/v2" {
    module {
        source = "../testdata/compliant/mock-tfplan-v2.sentinel"
    }
}

policy "digital-sovereignty" {
    source            = "./digital-sovereignty.sentinel"
    enforcement_level = "hard-mandatory"
}

policy "provider-supply-chain" {
    source            = "./provider-supply-chain.sentinel"
    enforcement_level = "hard-mandatory"
}

mock "tfplan/v2" {
    module {
        source = "../testdata/compliant/mock-tfplan-v2.sentinel"
    }
}

mock "tfconfig/v2" {
    module {
        source = "../testdata/compliant/mock-tfconfig-v2.sentinel"
    }
}

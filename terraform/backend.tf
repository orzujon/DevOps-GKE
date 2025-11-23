terraform {
    backend "gcs" {
        bucket = "tf-state-lithe-bonito-477114-a8"
        prefix = "infra/dev"
    }

    #if you already had a required version / required_providers block 
    #keep it here as well, dont remove it
}
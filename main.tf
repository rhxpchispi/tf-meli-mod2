# Simple include — recursos separados por archivo (aws.tf y gcp.tf)
# No contiene lógica, solo sirve de punto único de ejecución.
terraform {
    required_version = ">= 1.0.0"
    
    # A futuro se pueden incluir módulos por ej

    #module "aws" {
        #source = "./modules/aws"
        #...
    #}

    #module "gcp" {
        #source = "./modules/gcp"
        #...
    #}
}

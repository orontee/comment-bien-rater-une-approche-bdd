workspace {

    model {
        user = person "User" "Un utilisateur cherchant à acheter un vélo."

	webBrowser = softwareSystem "Boutique de vélo en ligne" "Navigateur web: Firefox, Chrome." "External"
        bikeStoreBackend = softwareSystem "Bike Store" "Service de vente de vélo."

        user -> webBrowser "Uses"
        webBrowser -> bikeStoreBackend "Call API" "HTTP/JSON"

        externalMusicProviders = group "Services tierces parties" {
            databaseServer = softwareSystem "Base de données" "Catalogue de vélos, bons de commande, etc." "External"
            paymentService = softwareSystem "Service paiement" "Carte Visa, Paypal, etc." "External"

            bikeStoreBackend -> databaseServer "Uses"
            bikeStoreBackend -> paymentService "Uses"
        }
    }

    views {
        systemLandscape "system-landscape" {
            include *
            autoLayout
        }
        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #cccccc
                color #ffffff
            }
        }
    }
}

user_email <- shiny::reactive({
  # Step 1: Get the key id from JWT headers
  encoded_jwt <- session$request$HTTP_X_AMZN_OIDC_DATA
  if (!is.null(encoded_jwt)) {
    jwt_headers <- strsplit(encoded_jwt, ".", fixed = TRUE)
    decoded_jwt_headers <- openssl::base64_decode(jwt_headers[[1]][1])
    decoded_json <- jsonlite::fromJSON(rawToChar(decoded_jwt_headers))
    kid <- decoded_json$kid
    
    # Step 2: Get the public key from regional endpoint
    region_endpoint <- stringr::str_extract(decoded_json$signer, "us-\\w+-\\d")
    url <- paste0("https://public-keys.auth.elb.", region_endpoint, ".amazonaws.com/", kid)
    req <- httr::GET(url)
    pub_key <- httr::content(req, as = "text", encoding = "UTF-8")
    
    # Step 3: Get the payload
    payload <- jose::jwt_decode_sig(jwt = encoded_jwt, pubkey = pub_key)
    
    print(paste0("User email: ", tolower(payload$email)))
    return(tolower(payload$email))
  } else if (is.null(encoded_jwt) && interactive()) {
    print(paste0("Local user email obtained from `GARGLE_EMAIL` (env var): ", Sys.getenv("GARGLE_EMAIL")))
    return(Sys.getenv("GARGLE_EMAIL"))
  } else {
    return("")
  }
})

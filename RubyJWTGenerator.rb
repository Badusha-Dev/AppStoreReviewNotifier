require "base64"  # Library for encoding/decoding base64 data
require "jwt"      # JSON Web Token (JWT) library for creating tokens
require "openssl"  # OpenSSL library for working with cryptographic keys

# Constants
ISSUER_ID = ENV['APP_STORE_CONNECT_ISSUER_ID']  # The App Store Connect Issuer ID from environment variables
KEY_ID = ENV['APP_STORE_CONNECT_KEY_ID']        # The Key ID associated with the private key used from environment variables

# Read the private key from the specified path
private_key = OpenSSL::PKey.read(File.read(ENV['APP_STORE_CONNECT_PRIVATE_KEY_PATH']))

# Create the JWT token
# JWT tokens are typically used for authentication and authorization purposes.
token = JWT.encode(
  {
    iss: ISSUER_ID,                # 'iss' is the Issuer ID, identifying the origin of the request
    exp: Time.now.to_i + 20 * 60,  # 'exp' is the expiration time for the token in UNIX timestamp (20 minutes from now)
    aud: "appstoreconnect-v1"     # 'aud' (audience) is set to specify the target service (App Store Connect API)
  },
  private_key,                    # The private key used for signing the JWT
  "ES256",                       # The signing algorithm to use (ES256 is used for Apple Store Connect)
  header_fields={
    kid: KEY_ID                   # 'kid' in the JWT header identifies the key used for signature
  }
)

# Print the generated token (you can use it as needed)
puts token

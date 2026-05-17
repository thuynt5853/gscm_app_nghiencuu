using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Web;

namespace BL.GSTP
{
    public class RSAHelprer
    {
        private RSACryptoServiceProvider rsa;
        public RSAHelprer()
        {
            const int PROVIDER_RSA_FULL = 1;
            string CONTAINER_NAME = "KeyContainer" + RandomString(15) + DateTime.UtcNow + "Drandom";
            CspParameters cspParams;
            cspParams = new CspParameters(PROVIDER_RSA_FULL);
            cspParams.KeyContainerName = CONTAINER_NAME;
            cspParams.Flags = CspProviderFlags.UseMachineKeyStore;
            cspParams.ProviderName = "Microsoft Strong Cryptographic Provider";

            rsa = new RSACryptoServiceProvider(1024, cspParams);
            rsa.PersistKeyInCsp = true;

            string publicPrivateKeyXML = rsa.ToXmlString(true);
            string publicOnlyKeyXML = rsa.ToXmlString(false);
            this.PublicKey = publicOnlyKeyXML;
            this.PrivateKey = publicPrivateKeyXML;
        }
        private string PublicKey { get; set; }
        private string PrivateKey { get; set; }
        private string RandomString(int size)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;
            for (int i = 0; i < size; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
                builder.Append(ch);
            }

            return builder.ToString();
        }
        public string Encryption(string data)
        {
            var dataBytes = Encoding.UTF8.GetBytes(data);
            try
            {
                var encryptedData = rsa.Encrypt(dataBytes, true);

                var base64Encrypted = Convert.ToBase64String(encryptedData);

                return base64Encrypted;
            }
            finally
            {
                rsa.PersistKeyInCsp = false;
            }
        }

        public string Decryption(string data)
        {
            try
            {
                var base64Encrypted = data;

                var resultBytes = Convert.FromBase64String(base64Encrypted);
                var decryptedBytes = rsa.Decrypt(resultBytes, true);
                var decryptedData = Encoding.UTF8.GetString(decryptedBytes);
                return decryptedData.ToString();
            }
            finally
            {
                rsa.PersistKeyInCsp = false;
            }
        }
    }
}
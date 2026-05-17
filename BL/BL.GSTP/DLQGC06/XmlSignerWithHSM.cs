using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography.Xml;
using System.Xml;


namespace BL.GSTP.DLQGC06
{
    public class XmlSignerWithHSM
    {
        /// <summary>
        /// Ký số file XML bằng chứng thư số trong HSM.
        /// </summary>
        /// <param name="inputXmlPath">Đường dẫn file XML gốc</param>
        /// <param name="outputXmlPath">Đường dẫn lưu file XML đã ký</param>
        /// <param name="certIdentifier">Chuỗi tìm kiếm chứng thư (Subject CN hoặc SerialNumber)</param>
        public void Sign(string inputXmlPath, string outputXmlPath, string certIdentifier)
        {
            X509Certificate2 cert = GetCertificateFromHSM(certIdentifier);
            SignXmlWithCert(inputXmlPath, outputXmlPath, cert);
        }

        private X509Certificate2 GetCertificateFromHSM(string subjectOrSerial)
        {
            X509Store store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);

            var cert = store.Certificates
                         .Cast<X509Certificate2>()
                         .FirstOrDefault(c =>
                             c.Subject.IndexOf(subjectOrSerial, StringComparison.OrdinalIgnoreCase) >= 0 ||
                             string.Equals(c.SerialNumber, subjectOrSerial, StringComparison.OrdinalIgnoreCase));

            store.Close();

            if (cert == null)
                throw new Exception($"Không tìm thấy chứng thư số trong HSM với: {subjectOrSerial}");
           
            if (!cert.HasPrivateKey)
                throw new Exception("Chứng thư tìm thấy không chứa private key. Không thể ký.");
            return cert;
        }

        private void SignXmlWithCert(string xmlPath, string outputPath, X509Certificate2 cert)
        {
            // Tải tài liệu XML gốc
            if (!cert.HasPrivateKey)
                throw new Exception("Chứng thư không chứa khóa bí mật. Không thể ký.");

            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.Load(xmlPath);

            if (doc.DocumentElement == null)
                throw new Exception("Tài liệu XML không hợp lệ hoặc không có phần tử gốc.");

            // Tạo đối tượng SignedXml với tài liệu
            SignedXml signedXml = new SignedXml(doc)
            {
                SigningKey = cert.PrivateKey
            };

            // Tạo đối tượng tham chiếu để ký toàn bộ tài liệu ("" = root)
            Reference reference = new Reference();
            reference.Uri = "";

            // Thêm biến đổi Enveloped để chèn chữ ký vào trong tài liệu
            reference.AddTransform(new XmlDsigEnvelopedSignatureTransform());

            // Thêm tham chiếu vào đối tượng ký
            signedXml.AddReference(reference);

            // Gắn thông tin chứng thư vào chữ ký
            KeyInfo keyInfo = new KeyInfo();
            keyInfo.AddClause(new KeyInfoX509Data(cert));
            signedXml.KeyInfo = keyInfo;

            // Tạo chữ ký số
            signedXml.ComputeSignature();

            // Gắn chữ ký vào tài liệu XML
            XmlElement signature = signedXml.GetXml();
            doc.DocumentElement.AppendChild(doc.ImportNode(signature, true));

            // Lưu tài liệu đã ký ra file
            doc.Save(outputPath);
        }
    }
}
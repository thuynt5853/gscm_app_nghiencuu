using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{

    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 11-ĐT:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân cấp huyện
    ///(ví dụ: Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
    ///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân cấp tỉnh.
    ///(2), (3) và(22) Ghi tên Tòa án nhân dân ghi nhận kết quả đối thoại, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc
    ///tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào(ví dụ: TÒA ÁN
    ///NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án nhân dân tỉnh(thành phố)
    ///đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
    ///(4) và(5) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ
    ///quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên(ví dụ: Anh Trần Văn B).
    ///(6), (7), (10), (11), (14) và(15) Chỉ ghi khi có người đại diện hợp pháp của người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ 
    ///liên quan và ghi họ tên, địa chỉ cư trú; ghi rõ là người đại diện theo pháp luật hay là người đại diện theo ủy quyền của người khởi kiện,
    ///người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu là người đại diện theo pháp luật thì cần ghi chú trong ngoặc đơn quan hệ giữa
    ///người đó với người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu là người đại diện theo ủy quyền thì cần ghi chú 
    ///trong ngoặc đơn: “văn bản ủy quyền ngày...tháng...năm...”.
    ///Ví dụ 1: Ông Nguyễn Văn A; cư trú tại...là người đại diện theo pháp luật của người khởi kiện(Giám đốc Công ty TNHH Thắng Lợi).
    ///Ví dụ 2: Bà Lê Thị B; cư trú tại...là người đại diện theo ủy quyền của người khởi kiện(Văn bản ủy quyền ngày...tháng...năm...).
    ///(8), (9), (12), (13), (16) và(17) Ghi như hướng dẫn tại điểm(4) và điểm(5).
    ///(18) Ghi tên Thẩm phán phụ trách hòa giải, đối thoại hoặc Thẩm phán khác do Chánh án Tòa án phân công tham gia phiên họp ghi nhận kết quả đối thoại.
    ///(19) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện đề nghị giải quyết.
    ///(20) Ghi cụ thể lần lượt những nội dung các bên đã thống nhất được.Trường hợp nội dung thống nhất đối thoại của các bên liên quan đến quyền, nghĩa 
    ///vụ của người khác nhưng người đó không có mặt tại phiên đối thoại thì phải được ghi rõ trong biên bản.
    ///(21) Ghi cụ thể lần lượt những nội dung các bên không thống nhất được.

    /// </summary>
    public partial class r11_DT
    {
        public r11_DT()
        {
            this.TOA_CAP_TREN = "                   ";
            this.TOA_HIEN_TAI ="                    ";
            this.GIO = "                    ";
            this.PHUT = "                   ";
            this.NGAY = "                   ";
            this.THANG = "                  ";
            this.NAM = "                    ";
            this.HOA_GIAI_VIEN = "                  ";
            this.NGUOI_KHOI_KIEN = "                   ";
            this.DIACHI_NGUOI_KHOI_KIEN ="                  ";
            this.NGUOI_DAI_DIEN_NKK = "                 ";
            this.DIACHI_NDD_NKK = "                 ";
            this.NGUOI_BI_KIEN = "                  ";
            this.DIACHI_NGUOI_BI_KIEN = "                  ";

            this.NGUOI_DAI_DIEN_NBK ="                  ";
            this.DIACHI_NDD_NBK = "                 ";
            this.NGUOI_LIEN_QUAN ="                 ";
            this.DIACHI_NGUOI_LIEN_QUAN = "                 ";
            this.NGUOI_DAI_DIEN_NLQ ="                  ";
            this.DIACHI_NDD_NLQ = "                 ";
            this.NGUOI_PHIEN_DICH = "                   ";
            this.DIACHI_NGUOI_PHIEN_DICH ="                 ";
            this.THAM_PHAN ="                   ";
            this.TEN_QHPL = "                   ";
            this.ND_THONG_NHAT = "                  ";
            this.ND_KHONG_THONG_NHAT ="                 ";
            this.CO = " ";
            this.KHONG = " ";
            this.GIO_KT ="                  ";
            this.PHUT_KT = "                    ";
            this.NGAY_KT = "                    ";
            this.THANG_KT = "                   ";
            this.NAM_KT = "                 ";
            this.SO_BAN = "                 ";
        }



        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân cấp huyện
        /// (ví dụ: Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
        /// THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ghi nhận kết quả đối thoại là Tòa án nhân dân cấp tỉnh.
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2), (3) và (22) Ghi tên Tòa án nhân dân ghi nhận kết quả đối thoại, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố 
        /// thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào (ví
        /// dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án nhân dân 
        /// tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String GIO { get; set; }
        public String PHUT { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }
        public String HOA_GIAI_VIEN { get; set; }

        /// <summary>
        /// (4) và (5) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ 
        /// của cơ quan, tổ chức. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên
        /// (ví dụ: Anh Trần Văn B).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }

        /// <summary>
        /// (6), (7), (10), (11), (14) và (15) Chỉ ghi khi có người đại diện hợp pháp của người khởi kiện, người bị kiện, người có quyền
        /// lợi, nghĩa vụ liên quan và ghi họ tên, địa chỉ cư trú; ghi rõ là người đại diện theo pháp luật hay là người đại diện theo ủy
        /// quyền của người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu là người đại diện theo pháp luật thì cần
        /// ghi chú trong ngoặc đơn quan hệ giữa người đó với người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu
        /// là người đại diện theo ủy quyền thì cần ghi chú trong ngoặc đơn: “văn bản ủy quyền ngày... tháng... năm...”.
        ///Ví dụ 1: Ông Nguyễn Văn A; cư trú tại...là người đại diện theo pháp luật của người khởi kiện(Giám đốc Công ty TNHH Thắng Lợi).
        ///Ví dụ 2: Bà Lê Thị B; cư trú tại...là người đại diện theo ủy quyền của người khởi kiện(Văn bản ủy quyền ngày...tháng...năm...).

        /// </summary>
        public String DIACHI_NGUOI_KHOI_KIEN { get; set; }
        public String NGUOI_DAI_DIEN_NKK { get; set; }
        public String DIACHI_NDD_NKK { get; set; }

        /// <summary>
        /// (8), (9), (12), (13), (16) và (17) Ghi như hướng dẫn tại điểm (4) và điểm (5).
        /// </summary>
        public String NGUOI_BI_KIEN { get; set; }
        public String DIACHI_NGUOI_BI_KIEN { get; set; }
        public String NGUOI_DAI_DIEN_NBK { get; set; }
        public String DIACHI_NDD_NBK { get; set; }
        public String NGUOI_LIEN_QUAN { get; set; }
        public String DIACHI_NGUOI_LIEN_QUAN { get; set; }
        public String NGUOI_DAI_DIEN_NLQ { get; set; }
        public String DIACHI_NDD_NLQ { get; set; }
        public String NGUOI_PHIEN_DICH { get; set; }
        public String DIACHI_NGUOI_PHIEN_DICH { get; set; }

        /// <summary>
        /// (18) Ghi tên Thẩm phán phụ trách hòa giải, đối thoại hoặc Thẩm phán khác do Chánh án Tòa án phân công tham gia phiên họp ghi nhận kết quả đối thoại.
        /// </summary>
        public String THAM_PHAN { get; set; }

        /// <summary>
        /// (19) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (20) Ghi cụ thể lần lượt những nội dung các bên đã thống nhất được. Trường hợp nội dung thống nhất đối thoại của các bên liên
        /// quan đến quyền, nghĩa vụ của người khác nhưng người đó không có mặt tại phiên đối thoại thì phải được ghi rõ trong biên bản.
        /// </summary>
        public String ND_THONG_NHAT { get; set; }

        /// <summary>
        /// (21) Ghi cụ thể lần lượt những nội dung các bên không thống nhất được.
        /// </summary>
        public String ND_KHONG_THONG_NHAT { get; set; }
        public String CO { get; set; }
        public String KHONG { get; set; }
        public String GIO_KT { get; set; }
        public String PHUT_KT { get; set; }
        public String NGAY_KT { get; set; }
        public String THANG_KT { get; set; }
        public String NAM_KT { get; set; }
        public String SO_BAN { get; set; }


    }
}
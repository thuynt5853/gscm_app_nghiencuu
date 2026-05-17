using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 10-ĐT:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện
    ///(ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
    ///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh.
    ///(2) Ghi tên Tòa án nhân dân ra thông báo, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh thì 
    ///ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào(ví dụ:
    ///TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án 
    ///nhân dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
    ///(3) và(4) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, 
    ///địa chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước
    ///khi ghi họ tên(ví dụ: Anh Trần Văn B).
    ///(5), (6), (9), (10), (13), (14), (17) và(18) Ghi như hướng dẫn tại điểm(3) và điểm(4).
    ///(7), (8), (11), (12), (15) và(16) Chỉ ghi khi có người đại diện hợp pháp của người khởi kiện, người bị kiện, người
    ///có quyền lợi, nghĩa vụ liên quan và ghi họ tên, địa chỉ cư trú; ghi rõ là người đại diện theo pháp luật hay là người
    ///đại diện theo ủy quyền của người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu là người đại 
    ///diện theo pháp luật thì cần ghi chú trong ngoặc đơn quan hệ giữa người đó với người khởi kiện, người bị kiện, người 
    ///có quyền lợi, nghĩa vụ liên quan; nếu là người đại diện theo ủy quyền thì cần ghi chú trong ngoặc đơn: “văn bản ủy 
    ///quyền ngày...tháng...năm...”.
    ///Ví dụ 1: Ông Nguyễn Văn A; cư trú tại...là người đại diện theo pháp luật của người khởi kiện(Giám đốc Công ty TNHH Thắng Lợi).
    ///Ví dụ 2: Bà Lê Thị B; cư trú tại...là người đại diện theo ủy quyền của người khởi kiện(Văn bản ủy quyền ngày...tháng...năm...).
    ///(19) Ghi tên Thẩm phán phụ trách hòa giải, đối thoại hoặc Thẩm phán khác do Chánh án Tòa án phân công tham gia phiên họp ghi 
    ///hận kết quả đối thoại.
    ///(20) Ghi tên người khởi kiện, người bị kiện như hướng dẫn tại điểm(3).
    ///(21) Ghi rõ lý do của việc hoãn phiên họp ghi nhận kết quả đối thoại thuộc trường hợp cụ thể nào quy định tại khoản 1 Điều 29 
    ///Luật Hòa giải, đối thoại tại Tòa án(ví dụ: Xét thấy người bị kiện đã được Hòa giải viên thông báo hợp lệ mà vắng mặt vì bị tai
    ///nạn lao động phải đi cấp cứu tại bệnh viện, ...).
    ///(22) Tùy từng trường hợp cụ thể mà ghi điểm, khoản, điều luật tương ứng của Điều 29 Luật Hòa giải, đối thoại tại Tòa án.

    /// </summary>
    public partial class r10_DT
    {
        public r10_DT()
        {
            this.TOA_CAP_TREN = "                   ";
            this.TOA_HIEN_TAI = "                   ";
            this.SO_VB = "                  ";
            this.DIA_CHI = "                    ";
            this.NGAY = "                   ";
            this.THANG = "                  ";
            this.NAM = "                    ";
            this.NGUOI_NHAN ="                  ";
            this.DIACHI_NGUOI_NHAN = "                  ";
            this.SDT_NGUOI_NHAN = "                 ";
            this.FAX_NGUOI_NHAN = "                 ";
            this.MAIL_NGUOI_NHAN ="                 ";
            this.HOA_GIAI_VIEN = "                  ";
            this.NGUOI_KHOI_KIEN = "                    ";
            this.DIACHI_NGUOI_KHOI_KIEN = "                 ";
            this.NGUOI_DAI_DIEN_NKK = "                 ";
            this.DIACHI_NDD_NKK = "                    ";
            this.NGUOI_BI_KIEN ="                   ";
            this.DIACHI_NGUOI_BI_KIEN ="                    ";
            this.NGUOI_DAI_DIEN_NBK ="                  ";
            this.DIACHI_NDD_NBK ="                  ";
            this.NGUOI_LIEN_QUAN = "                    ";
            this.DIACHI_NGUOI_LIEN_QUAN = "                 ";
            this.NGUOI_DAI_DIEN_NLQ = "                 ";
            this.DIACHI_NDD_NLQ = "                 ";
            this.NGUOI_PHIEN_DICH ="                    ";
            this.DIACHI_NGUOI_PHIEN_DICH ="                 ";
            this.THAM_PHAN = "                  ";
            this.NGAY_HOAN = "                  ";
            this.THANG_HOAN = "                 ";
            this.NAM_HOAN = "                   ";
            this.LY_DO = "                  ";
            this.DIEU_LUAT = "                  ";
            this.SDT_HOA_GIAI_VIEN = "                  ";
        }



        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện 
        /// (ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN
        /// THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2) Ghi tên Tòa án nhân dân ra thông báo, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh thì 
        /// ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào (ví 
        /// dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa
        /// án nhân dân tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String SO_VB { get; set; }
        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }

        /// <summary>
        /// (3) và (4) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi 
        /// tên, địa chỉ của cơ quan, tổ chức. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc 
        /// Chị trước khi ghi họ tên (ví dụ: Anh Trần Văn B).
        /// </summary>
        public String NGUOI_NHAN { get; set; }
        public String DIACHI_NGUOI_NHAN { get; set; }
        public String SDT_NGUOI_NHAN { get; set; }
        public String FAX_NGUOI_NHAN { get; set; }
        public String MAIL_NGUOI_NHAN { get; set; }
        public String HOA_GIAI_VIEN { get; set; }

        /// <summary>
        /// (5), (6), (9), (10), (13), (14), (17) và (18) Ghi như hướng dẫn tại điểm (3) và điểm (4).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }
        public String DIACHI_NGUOI_KHOI_KIEN { get; set; }

        /// <summary>
        /// (7), (8), (11), (12), (15) và (16) Chỉ ghi khi có người đại diện hợp pháp của người khởi kiện, người bị kiện, người 
        /// có quyền lợi, nghĩa vụ liên quan và ghi họ tên, địa chỉ cư trú; ghi rõ là người đại diện theo pháp luật hay là người 
        /// đại diện theo ủy quyền của người khởi kiện, người bị kiện, người có quyền lợi, nghĩa vụ liên quan; nếu là người đại 
        /// diện theo pháp luật thì cần ghi chú trong ngoặc đơn quan hệ giữa người đó với người khởi kiện, người bị kiện, người 
        /// có quyền lợi, nghĩa vụ liên quan; nếu là người đại diện theo ủy quyền thì cần ghi chú trong ngoặc đơn: “văn bản ủy 
        /// quyền ngày... tháng... năm...”.
        /// Ví dụ 1: Ông Nguyễn Văn A; cư trú tại...là người đại diện theo pháp luật của người khởi kiện(Giám đốc Công ty TNHH Thắng Lợi).
        ///Ví dụ 2: Bà Lê Thị B; cư trú tại...là người đại diện theo ủy quyền của người khởi kiện(Văn bản ủy quyền ngày...tháng...năm...).

        /// </summary>
        public String NGUOI_DAI_DIEN_NKK { get; set; }
        public String DIACHI_NDD_NKK { get; set; }
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
        /// (19) Ghi tên Thẩm phán phụ trách hòa giải, đối thoại hoặc Thẩm phán khác do Chánh án Tòa án phân công tham gia 
        /// phiên họp ghi nhận kết quả đối thoại
        /// </summary>
        public String THAM_PHAN { get; set; }
        public String NGAY_HOAN { get; set; }
        public String THANG_HOAN { get; set; }
        public String NAM_HOAN { get; set; }

        /// <summary>
        /// (21) Ghi rõ lý do của việc hoãn phiên họp ghi nhận kết quả đối thoại thuộc trường hợp cụ thể nào quy định tại 
        /// khoản 1 Điều 29 Luật Hòa giải, đối thoại tại Tòa án (ví dụ: Xét thấy người bị kiện đã được Hòa giải viên thông 
        /// báo hợp lệ mà vắng mặt vì bị tai nạn lao động phải đi cấp cứu tại bệnh viện, ...).
        /// </summary>
        public String LY_DO { get; set; }

        /// <summary>
        /// (22) Tùy từng trường hợp cụ thể mà ghi điểm, khoản, điều luật tương ứng của Điều 29 Luật Hòa giải, đối thoại tại Tòa án.
        /// </summary>
        public String DIEU_LUAT { get; set; }
        public String SDT_HOA_GIAI_VIEN { get; set; }

    }
}
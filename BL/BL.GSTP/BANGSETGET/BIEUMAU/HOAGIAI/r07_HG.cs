using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
/// <summary>
/// Hướng dẫn sử dụng mẫu số 07-HG:
///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện 
///(ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ANS NHÂN DÂN 
///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh.
///(2), (3) và(7) Ghi tên Tòa án nhân dân ra thông báo, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc 
///tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương 
///nào(ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì 
///ghi Tòa án nhân dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM). 
///(4) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
///(5) và(6) Ghi tên và địa chỉ của người khởi kiện/người yêu cầu, người bị kiện, người có quyền lợi, nghĩa vụ liên 
///quan; nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa 
///chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi 
///ghi họ tên(ví dụ: “Kính gửi: Anh Trần Văn B”).
///(8) Ghi tên người được gửi thông báo.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị 
///trước khi ghi họ tên(ví dụ: “Kính gửi: Anh Trần Văn B”).

/// </summary>
    public partial class r07_HG
    {
        public r07_HG()
        {
            this.TOA_CAP_TREN = "                               "; 
            this.TOA_HIEN_TAI = "                               "; 
            this.SO_THONG_BAO = "                               ";
            this.DIA_CHI = "                                "; 
            this.NGAY = "                               "; 
            this.THANG = "                              ";
            this.NAM = "                                "; 
            this.THOI_GIAN = "                              ";
            this.TEN_QHPL = "                               ";
            this.NGUOI_KHOI_KIEN = "                                "; 
            this.NGUOI_BI_KIEN = "                              "; 
            this.NGUOI_LIEN_QUAN = "                                "; 
            this.TOA_HIEN_TAI_DIACHI = "                                "; 
            this.TOA_HIEN_TAI_MAIL = "                              "; 
            this.TOA_HIEN_TAI_FAX = "                               "; 
            this.NGUOI_KY = "                               "; 
        }


        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp
        /// huyện (ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA
        /// ÁN NHÂN DÂN THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án 
        /// nhân dân cấp tỉnh.
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2), (3) và (7) Ghi tên Tòa án nhân dân ra thông báo, nếu là Tòa án nhân dân huyện, quận, thị xã, thành 
        /// phố thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực 
        /// thuộc Trung ương nào (ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố 
        /// trực thuộc Trung ương thì ghi Tòa án nhân dân tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM). 
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String SO_THONG_BAO { get; set; }
        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }
        public String THOI_GIAN { get; set; }

        /// <summary>
        /// (4) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (5) và (6) Ghi tên và địa chỉ của người khởi kiện/người yêu cầu, người bị kiện, người 
        /// có quyền lợi, nghĩa vụ liên quan; nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và 
        /// nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ chức. Cần lưu 
        /// ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ 
        /// tên (ví dụ: “Kính gửi: Anh Trần Văn B”).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }
        public String NGUOI_BI_KIEN { get; set; }
        public String NGUOI_LIEN_QUAN { get; set; }

        /// <summary>
        /// (8) Ghi tên người được gửi thông báo. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà 
        /// ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên (ví dụ: “Kính gửi: Anh Trần Văn B”).
        /// </summary>
        public String NGUOI_NHAN_TB { get; set; }
        public String TOA_HIEN_TAI_DIACHI { get; set; }
        public String TOA_HIEN_TAI_MAIL { get; set; }
        public String TOA_HIEN_TAI_FAX { get; set; }
        public String NGUOI_KY { get; set; }
    }
}
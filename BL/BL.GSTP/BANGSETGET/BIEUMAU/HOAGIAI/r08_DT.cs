using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 08-ĐT:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân gửi giấy mời là Tòa án nhân dân cấp huyện
    ///(ví dụ: Tòa án nhân dân gửi giấy mời là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
    ///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân gửi giấy mời là Tòa án nhân dân cấp tỉnh.
    ///(2) và(5) Ghi tên Tòa án nhân dân gửi giấy mời, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh 
    ///thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào(ví 
    ///dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa 
    ///án nhân dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
    ///(3) và(4) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên,
    ///địa chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước
    ///khi ghi họ tên(ví dụ: Anh Trần Văn B).
    ///(6) Ghi rõ địa điểm, địa chỉ sẽ diễn ra phiên đối thoại.
    ///(7) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
    ///(8) Ghi tóm tắt nội dung các yêu cầu, khiếu kiện của người khởi kiện.
    ///(9) Ghi tên Hòa giải viên được chỉ định đối thoại khiếu kiện.

    /// </summary>
    public partial class r08_DT
    {
        public r08_DT()
        {
            this.TOA_CAP_TREN = "                   ";
            this.TOA_HIEN_TAI = "                   "; 
            this.SO_VB = "                  ";
            this.DIA_CHI = "                    ";
            this.NGAY = "                   ";
            this.THANG = "                  ";
            this.NAM = "                    "; 
            this.NGUOI_NHAN = "                 "; 
            this.DIACHI_NGUOI_NHAN = "                  "; 
            this.SDT_NGUOI_NHAN = "                 "; 
            this.FAX_NGUOI_NHAN = "                 ";
            this.MAIL_NGUOI_NHAN = "                    "; 
            this.GIO_MOI = "                    "; 
            this.PHUT_MOI = "                   "; 
            this.NGAY_MOI = "                   "; 
            this.THANG_MOI = "                  "; 
            this.NAM_MOI = "                    "; 
            this.DIA_DIEM=
            this.DIACHI_MOI = "                    ";
            this.TEN_QHPL = "                   "; 
            this.NGUOI_KHOI_KIEN = "                    "; 
            this.NGUOI_BI_KIEN = "                  ";
            this.NGUOI_LIEN_QUAN = "                    ";
            this.NOI_DUNG = "                   "; 
            this.HOA_GIAI_VIEN = "                  ";
            this.SDT_HOA_GIAI_VIEN = "                  "; 
        }



        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân gửi giấy mời là Tòa án nhân dân cấp huyện
        /// (ví dụ: Tòa án nhân dân gửi giấy mời là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
        /// THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân gửi giấy mời là Tòa án nhân dân cấp tỉnh.
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2) và (5) Ghi tên Tòa án nhân dân gửi giấy mời, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh 
        /// thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào (ví 
        /// dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án 
        /// nhân dân tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String SO_VB { get; set; }
        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }

        /// <summary>
        /// (3) và (4) Nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, 
        /// địa chỉ của cơ quan, tổ chức. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước 
        /// khi ghi họ tên (ví dụ: Anh Trần Văn B).
        /// </summary>
        public String NGUOI_NHAN { get; set; }
        public String DIACHI_NGUOI_NHAN { get; set; }
        public String SDT_NGUOI_NHAN { get; set; }
        public String FAX_NGUOI_NHAN { get; set; }
        public String MAIL_NGUOI_NHAN { get; set; }
        public String GIO_MOI { get; set; }
        public String PHUT_MOI { get; set; }
        public String NGAY_MOI { get; set; }
        public String THANG_MOI { get; set; }
        public String NAM_MOI { get; set; }

        /// <summary>
        /// (6) Ghi rõ địa điểm, địa chỉ sẽ diễn ra phiên đối thoại.
        /// </summary>
        /// 
        public String DIA_DIEM { get; set; }
        public String DIACHI_MOI { get; set; }

        /// <summary>
        /// (7) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }
        public String NGUOI_KHOI_KIEN { get; set; }
        public String NGUOI_BI_KIEN { get; set; }
        public String NGUOI_LIEN_QUAN { get; set; }

        /// <summary>
        /// (8) Ghi tóm tắt nội dung các yêu cầu, khiếu kiện của người khởi kiện.
        /// </summary>
        public String NOI_DUNG { get; set; }

        /// <summary>
        /// (9) Ghi tên Hòa giải viên được chỉ định đối thoại khiếu kiện.
        /// </summary>
        public String HOA_GIAI_VIEN { get; set; }
        public String SDT_HOA_GIAI_VIEN { get; set; }
    }
}
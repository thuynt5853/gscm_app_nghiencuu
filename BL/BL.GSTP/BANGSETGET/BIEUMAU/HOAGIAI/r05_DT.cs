using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 05-ĐT:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện
    ///(ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
    ///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh.
    ///(2) (5) (6) (11) và(12) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc, nếu là Tòa án nhân dân huyện, quận,
    ///thị xã, thành phố thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố 
    ///trực thuộc Trung ương nào(ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực 
    ///thuộc Trung ương thì ghi Tòa án nhân dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM). 
    ///(3) (10) và(13) Ghi tên Tòa án nhân dân có thẩm quyền giải quyết khiếu kiện như hướng dẫn tại điểm(2).
    ///(4) và(7) Ghi họ tên Hòa giải viên được lựa chọn.
    ///(8) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
    ///(9) Ghi tên và địa chỉ người khởi kiện, Người bị kiện nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và nơi làm 
    ///việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, thì tùy theo độ 
    ///tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên(ví dụ: Kính gửi: Anh Trần Văn B).
    /// </summary>
    public partial class r05_DT
    {
        public r05_DT()
        {
            this.TOA_CAP_TREN = "                       "; 
            this.TOA_HIEN_TAI = "                       ";
            this.TOA_HGV = "                              ";
            this.SO_TB = "                      "; 
            this.DIA_CHI = "                        "; 
            this.NGAY = "                       "; 
            this.THANG = "                      "; 
            this.NAM = "                        "; 
            this.TOA_THAM_QUYEN = "                     "; 
            this.HOA_GIAI_VIEN = "                      "; 
            this.TEN_QHPL = "                       "; 
            this.NGUOI_KHOI_KIEN = "                        "; 
            this.NGUOI_BI_KIEN = "                      "; 
            this.THOI_GIAN = "                      "; 
            this.DONG_Y = " "; 
            this.KO_DONG_Y = " ";
            this.NGUOI_KY = "                       "; 
        }

        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp huyện
        /// (ví dụ: Tòa án nhân dân ra thông báo là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN
        /// THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra thông báo là Tòa án nhân dân cấp tỉnh.
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2) (5) (6) (11) và (12) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc, nếu là Tòa án nhân dân huyện, quận, 
        /// thị xã, thành phố thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố
        /// trực thuộc Trung ương nào (ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực 
        /// thuộc Trung ương thì ghi Tòa án nhân dân tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM). 
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String TOA_HGV {  get; set; }
        public String SO_TB { get; set; }
        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }

        /// <summary>
        /// (3) (10) và (13) Ghi tên Tòa án nhân dân có thẩm quyền giải quyết khiếu kiện như hướng dẫn tại điểm (2).
        /// </summary>
        public String TOA_THAM_QUYEN { get; set; }

        /// <summary>
        /// (4) và (7) Ghi họ tên Hòa giải viên được lựa chọn.
        /// </summary>
        public String HOA_GIAI_VIEN { get; set; }

        /// <summary>
        /// (8) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (9) Ghi tên và địa chỉ người khởi kiện, Người bị kiện nếu là cá nhân thì ghi họ tên, địa chỉ nơi cư trú và 
        /// nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ chức. Cần lưu ý đối với cá nhân, 
        /// thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên (ví dụ: Kính gửi: Anh Trần Văn B).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }
        public String NGUOI_BI_KIEN { get; set; }
        public String THOI_GIAN { get; set; }
        public String DONG_Y { get; set; }
        public String KO_DONG_Y { get; set; }
        public String NGUOI_KY { get; set; }
    }
}
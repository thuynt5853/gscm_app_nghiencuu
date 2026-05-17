using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 04-HG:
    ///(1) (7) và(8) Ghi tên Tòa án nhân dân có thẩm quyền giải quyết vụ việc.
    ///(2) (4) và(9) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc.
    ///(3) Ghi tên người khởi kiện/người yêu cầu, nếu là cá nhân thì ghi họ tên, địa chỉ nơi 
    ///cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ 
    ///chức.Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị 
    ///trước khi ghi họ tên(ví dụ: Kính gửi: Anh Trần Văn B).
    ///(5) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
    ///(6) Ghi tên người khởi kiện/người yêu cầu, người bị kiện như hướng dẫn tại điểm(3).

    /// </summary>
    public partial class r04_DT
    {
        public r04_DT()
        {
            this.DIA_CHI = "      ";
            this.NGAY = "       ";
            this.THANG = "    ";
            this.NAM = "   ";
            this.TOA_HGV = "                   ";
            this.TOA_HIEN_TAI = "                   ";
            this.NGUOI_KHOI_KIEN = "                     ";
            this.HOA_GIAI_VIEN = "                  ";
            this.TEN_QHPL = "                   ";
            this.NGUOI_BI_KIEN = "                  ";
            this.DONG_Y = " ";
            this.KO_DONG_Y = " ";
        }

        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }

        /// <summary>
        /// (1) (7) và (8) Ghi tên Tòa án nhân dân có thẩm quyền giải quyết vụ việc.
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }

        /// <summary>
        /// (2) (4) và (9) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc.
        /// </summary>
        public String TOA_HGV { get; set; }

        /// <summary>
        /// (3) Ghi tên người khởi kiện/người yêu cầu, nếu là cá nhân thì ghi họ tên, địa chỉ nơi 
        /// cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ 
        /// chức. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị 
        /// trước khi ghi họ tên (ví dụ: Kính gửi: Anh Trần Văn B).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }
        public String HOA_GIAI_VIEN { get; set; }

        /// <summary>
        /// (5) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (6) Ghi tên người khởi kiện/người yêu cầu, người bị kiện như hướng dẫn tại điểm (3).
        /// </summary>
        public String NGUOI_BI_KIEN { get; set; }
        public String DONG_Y { get; set; }
        public String KO_DONG_Y { get; set; }

    }
}
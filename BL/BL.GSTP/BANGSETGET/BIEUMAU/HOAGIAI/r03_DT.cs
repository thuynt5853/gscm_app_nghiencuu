using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    ///    Hướng dẫn sử dụng mẫu số 03-ĐT:
    ///(1) Ghi đầy đủ họ, tên, chức vụ của người ghi nhận ý kiến và địa chỉ của Tòa án nơi ghi nhận ý kiến.
    ///(2) Ghi đầy đủ họ, tên, chức vụ và địa chỉ nơi cư trú hoặc nơi làm việc của người trình bày ý kiến.
    ///(3) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
    ///(4) và(5) Ghi thông tin mục này khi người khởi kiện, người yêu cầu có sự lựa chọn Hòa giải viên.

    /// <summary>
    public partial class r03_DT
    {
        public r03_DT()
        {
            this.GIO = "        ";
            this.PHUT = "       ";
            this.NGAY = "       ";
            this.THANG = "      ";
            this.NAM = "        ";
            this.DIA_CHI_TOA_AN = "                                 ";
            this.NGUOI_NHAN_Y_KIEN = "                              ";
            this.NGUOI_GHI_Y_KIEN = "                               ";
            this.DIA_CHI_NGUOI_Y_KIEN = "                               ";
            this.TEN_QHPL = "                              ";
            this.HOA_GIAI_VIEN = "                                ";
            this.DIA_CHI_HGV = "                                        ";
            this.TEN_TOA_AN = "                                         ";
            this.DONG_Y = " ";
            this.KO_DONG_Y = " ";
            this.CO = " ";
            this.KHONG = " ";
            this.CHUC_VU = " ";
        }

        public String GIO { get; set; }
        public String PHUT { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }
        public String DIA_CHI_TOA_AN { get; set; }

        /// <summary>
        /// (1) Ghi đầy đủ họ, tên, chức vụ của người ghi nhận ý kiến và địa chỉ của Tòa án nơi ghi nhận ý kiến.
        /// </summary>
        /// 
        public String CHUC_VU { get; set; }
        public String NGUOI_NHAN_Y_KIEN { get; set; }

        /// <summary>
        /// (2) Ghi đầy đủ họ, tên, chức vụ và địa chỉ nơi cư trú hoặc nơi làm việc của người trình bày ý kiến.
        /// <summary>
        public String NGUOI_GHI_Y_KIEN { get; set; }
        public String DIA_CHI_NGUOI_Y_KIEN { get; set; }

        /// <summary>
        /// (3) Ghi quan hệ tranh chấp mà người khởi kiện đề nghị giải quyết.
        /// <summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (4) và (5) Ghi thông tin mục này khi người khởi kiện, người yêu cầu có sự lựa chọn Hòa giải viên.
        /// </summary>
        public String HOA_GIAI_VIEN { get; set; }
        public String DIA_CHI_HGV { get; set; }
        public String TEN_TOA_AN { get; set; }

        public String DONG_Y { get; set; }
        public String KO_DONG_Y { get; set; }

        public String CO { get; set; }
        public String KHONG { get; set; }

    }
}

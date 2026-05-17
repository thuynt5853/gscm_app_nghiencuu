using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHN
{
	public class AHN_DON_DUONGSU_HIS
	{
			public string DUONGSU_XML { get; set; }

            public string HIS_NGUOISUA { get; set; }
            public string HIS_TAIKHOANSUA { get; set; }
            public DateTime? HIS_NGAYSUA { get; set; }

            // Thêm các cột khác trong bảng AHN_DON_DUONGSU_HISTORY nếu cần
	}
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace Module.Common
{
    public class ClsHelper
    {
        public static List<ListItem> GetEnumLoaiAn()
        {
            return new List<ListItem>
            {
                new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU),
                new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU),
                new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH),
                new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH),
                new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI),
                new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG),
                new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN)
            };
        }
    }
}
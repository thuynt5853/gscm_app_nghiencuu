using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Data;
using System.Globalization;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class HuongDan : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }
        void LoadData()
        {
            Decimal GroupId = Convert.ToDecimal( hddGroupNews.Value);
            DONKK_CHUYENMUC objCM = dt.DONKK_CHUYENMUC.Where(x => x.ID == GroupId && x.HIEULUC == 1).Single<DONKK_CHUYENMUC>();           
            if (objCM != null)
                lttTieuDe.Text = objCM.TENCHUYENMUC;

            int soluong = Convert.ToInt32(hddSoLuong.Value);
            DonKK_TinTuc_BL obj = new DonKK_TinTuc_BL();
            DataTable tbl = obj.GetTopByGroupCMID(soluong, GroupId);
            if (tbl != null && tbl.Rows.Count>0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
        }
    }
}
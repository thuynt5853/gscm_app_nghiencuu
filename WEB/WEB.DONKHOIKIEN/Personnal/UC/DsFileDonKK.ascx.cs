
using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK.DanhMuc;

namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class DsFileDonKK : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");

        //--------------------------------
        private decimal donid;
        public decimal DonKKID
        {
            get { return donid; }
            set { donid = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
                LoadDsFileTheoDonKK();
            //else
            //    Response.Redirect("/trangchu.aspx");
        }
        void LoadDsFileTheoDonKK()
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID
                                                                       && x.TAILIEUID == 0
                                                                       ).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                rpt.DataSource = lst;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else rpt.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "dowload":
                    DowloadFile_VuViec(Convert.ToDecimal(e.CommandArgument));
                    break;
            }
        }
        void DowloadFile_VuViec(Decimal FileID)
        {
            try
            {
                DONKK_DON_TAILIEU oND = dt.DONKK_DON_TAILIEU.Where(x => x.ID == FileID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                }
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = ex.Message;
            }
        }

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;
using System.Data;
using Module.Common;

namespace WEB.DONKHOIKIEN
{   
    public partial class DSTin : System.Web.UI.Page
    {
        public int HasChild = 0;
        DKKContextContainer dt = new DKKContextContainer();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    LoadGroupNews();
                }
                catch (Exception ex) { }
            }
        }

        #region Load Group News
        void LoadGroupNews()
        {
            DONKK_CHUYENMUC obj = new DONKK_CHUYENMUC();
            int cmID = 0;
            if (!string.IsNullOrEmpty(Request["cID"] + ""))
                cmID = Convert.ToInt32(Request["cID"] + "");

            List<DONKK_CHUYENMUC> lst= dt.DONKK_CHUYENMUC.Where(x => x.CAPCHAID == cmID).ToList<DONKK_CHUYENMUC>();
            if (lst != null && lst.Count > 0) 
            {
                rptNhomTinTuc.DataSource = lst;
                rptNhomTinTuc.DataBind();
            }
            else
            {
                LoadListData();
            }
        }

        protected void rptNhomTinTuc_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DONKK_CHUYENMUC obj_CM = (DONKK_CHUYENMUC)e.Item.DataItem;
                Panel pnGroup = (Panel)e.Item.FindControl("pnGroup");
                Literal ltrTieuDeNhomTin = (Literal)e.Item.FindControl("ltrTieuDeNhomTin");
                Literal ltrXemthem = (Literal)e.Item.FindControl("ltrXemthem");
                string strTenCM = obj_CM.TENCHUYENMUC;
                ltrTieuDeNhomTin.Text = "<a href='/DStin.aspx?cID=" + obj_CM.ID + "' class='tieudiem_head_title'>" + strTenCM + "<div class='arrow-down'></div></a>";
                ltrXemthem.Text = "<span><a href='/DStin.aspx?cID=" + obj_CM.ID + "'>Xem thêm</a></span>";

                //Lay top tin moi nhat cua chuyen muc
                DONKK_TINTUC obj_tintuc = new DONKK_TINTUC();
                DonKK_TinTuc_BL obj_tintuc_bl = new DonKK_TinTuc_BL();
                DataTable tbl;
                pnGroup.Visible = false;
                try
                {
                    int sluong = 5;
                    String cache_name = "GetTopTinFilterNewsID.danhsachtin." + obj_CM.ID + "." + sluong;
                    if (Cache[cache_name] == null)
                    {
                        decimal cmID = Convert.ToDecimal(obj_CM.ID);
                        tbl = obj_tintuc_bl.GetTopByGroupCMID(5, cmID);
                        Cache.Add(cache_name, tbl, null, DateTime.Now.AddMinutes(10), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                    }
                    else
                        tbl = (DataTable)Cache[cache_name];

                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        pnGroup.Visible = true;
                        //Load vao danh sach cac tin moi nhat
                        Repeater rptTinBai = (Repeater)e.Item.FindControl("rptTinBai");
                        rptTinBai.DataSource = tbl;
                        rptTinBai.DataBind();
                    }
                }
                catch (Exception exTin) { }
            }
        }
        protected void rptTinBai_ItemDataBound(object o, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DataRowView tb = (DataRowView)e.Item.DataItem;

                Literal ltrTinBai = (Literal)e.Item.FindControl("ltrTinBai");
                string tieude = tb["TIEUDE"] + "";
                ltrTinBai.Text = "<a href='ChiTietTin.aspx?tID="+ tb["ID"] + "&&cID=" + tb["CHUYENMUCID"] + "'>" + tieude+ "<span class='linktin_datetime'>(" + Convert.ToDateTime(tb["NGAYTINBAI"]).ToString("dd/MM/yyyy") + ")</span></a>";
            }
        }

        #endregion

    
        void LoadListData()
        {
            pnListNews.Visible = true;
            pnGroupNews.Visible = false;
            LoadListNews();
        }
        private void LoadListNews()
        {
            int cmID = 0;
            if (!string.IsNullOrEmpty(Request["cID"] + ""))
                cmID = Convert.ToInt32(Request["cID"] + "");
            DONKK_CHUYENMUC obj = dt.DONKK_CHUYENMUC.Where(x => x.ID == cmID).SingleOrDefault<DONKK_CHUYENMUC>();

            if(obj!=null)
            {
                ltltieude.Text = "<a href='javascript:;' class='tieudiem_head_title'>" + obj.TENCHUYENMUC + "</a>";
            }

            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DonKK_TinTuc_BL obj_tintuc_bl = new DonKK_TinTuc_BL();
            DataTable tbl = null;
            tbl = obj_tintuc_bl.GetAllPaging("", cmID, 2,pageindex, page_size);
            if (tbl != null)
            {
                int count_all = tbl.Rows.Count;
                Int64 all_item = Convert.ToInt64(tbl.Rows[0]["COUNTALL"] + "");                

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text =  "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbTFirst, lbTLast, lbTLast, lbTNext, lbTNext, lbTBack, lbTBack, lbTStep1, lbTStep1, lbTStep2,
                             lbTStep2, lbTStep3, lbTStep3, lbTStep4, lbTStep4, lbTStep5, lbTStep5, lbTStep6, lbTStep6);
                #endregion
                
                //string temp = "";
                tbl.Columns.Add("StrNgayTinBai", typeof(String));
                tbl.Columns.Add("CurrentLink", typeof(string));
                string ngaytinbai;
                foreach (DataRow row in tbl.Rows)
                {
                    row["CurrentLink"] = "ChiTietTin.aspx?tID=" + row["ID"] + "&&cID=" + row["CHUYENMUCID"];
                    ngaytinbai = string.Format("{0:dd/MM/yyyy}", row["NGAYTINBAI"]);
                    row["StrNgayTinBai"] = ((ngaytinbai == "01/01/1900") ? "" : ("<span>Ngày " + ngaytinbai + "&nbsp;&nbsp;</span>"));
                }

                //Load list tin hien thi chi tiet 
                rptListTin.DataSource = tbl;
                rptListTin.DataBind();
            }
            else
            {

                pnPhantrang.Visible = false;
                lbthongbao.Text = "<span class='error_msg'>Không tìm thấy kết quả phù hợp với yêu cầu !</span>";
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadListNews();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadListNews();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadListNews();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadListNews();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadListNews();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}
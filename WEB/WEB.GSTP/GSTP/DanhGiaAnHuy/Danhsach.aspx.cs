using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.DanhGiaAnHuy
{
    public partial class Danhsach : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadData();
                    if (Request["tt"] + "" == "1")
                    {
                        lbthongbao.Text = "Lưu đánh giá thành công!";
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            DataTable db = new DataTable();
            db.Columns.Add("ID", typeof(int));
            db.Columns.Add("STT", typeof(int));
            db.Columns.Add("TenVuAn", typeof(string));
            db.Columns.Add("TrangThai", typeof(string));
            db.Columns.Add("TenToaAn", typeof(string));
            db.Columns.Add("VaiTro", typeof(string));
            db.Columns.Add("TP_DanhGia", typeof(string));
            db.Columns.Add("TP_Lydo", typeof(string));
            db.Columns.Add("UBTP_DanhGia", typeof(string));
            db.Columns.Add("UBTP_Lydo", typeof(string));

            DataRow row = db.NewRow();
            row["ID"] = "5";
            row["STT"] = "1";
            row["TenVuAn"] = "Triệt phá đường dây buôn bán hàng giả xuyên biên giới tại cửa khẩu quốc tế Lào Cai.";
            row["TrangThai"] = "Án sửa";
            row["TenToaAn"] = "Tòa án nhân dân tỉnh Lào Cai";
            row["VaiTro"] = "Chủ tọa";
            row["TP_DanhGia"] = "Chủ quan";
            row["TP_Lydo"] = "Thiếu thông tin";
            row["UBTP_DanhGia"] = "Chủ quan";
            row["UBTP_Lydo"] = "Thiếu thông tin";
            db.Rows.Add(row);

            row = db.NewRow();
            row["ID"] = "3";
            row["STT"] = "2";
            row["TenVuAn"] = "Tranh chấp quyền sở hữu.";
            row["TrangThai"] = "Án hủy";
            row["TenToaAn"] = "Tòa án nhân dân tỉnh Lào Cai";
            row["VaiTro"] = "Thành phần HĐXX";
            row["TP_DanhGia"] = "Khách quan";
            row["TP_Lydo"] = "Có tình tiết mới";
            row["UBTP_DanhGia"] = "Khách quan";
            row["UBTP_Lydo"] = "Có tình tiết mới";
            db.Rows.Add(row);

            int Total = db.Rows.Count, pageSize = Convert.ToInt32(hddPageSize.Value);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            rptData.DataSource = db;
            rptData.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadData();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadData();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadData();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadData();
        }
        #endregion
        protected void rptData_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    HtmlTableRow tr = (HtmlTableRow)e.Item.FindControl("rowCss");
                    int rowIndex = e.Item.ItemIndex;
                    if (rowIndex % 2 == 0)
                    {
                        tr.Attributes["Class"] = "chan";
                    }
                    else
                    {
                        tr.Attributes["Class"] = "le";
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void rptData_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    string link = Cls_Comon.GetRootURL() + "/GSTP/Capnhatdanhgia.aspx?dg=" + e.CommandArgument.ToString();
                    Response.Redirect(link);
                    break;
            }
        }
    }
}
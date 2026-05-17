using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.CBBA;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WEB.GSTP.BaoCao.Thongtinvuviec
{   
    public partial class QuanLyCBBA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ResetControl()
        {
            txtMaVuViec.Text = "";
            txtNgayMoPhienToa.Text = "";
            txtBidonBicao.Text = "";
            txtTenVuViec.Text = "";
            txtBAQD.Text = "";
            txtNgayBAQD.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            dropLoaian.SelectedValue = "0" ;
            //dropNguoiKi.SelectedValue = "0";
            ddTrangthai.SelectedValue = "-1";
        }
        //private void LoadNguoiKi()
        //{
        //    dropNguoiKi.Items.Add(new ListItem("Tất cả", "0"));

        //}
        //protected void dropNguoiKi_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    var nguoiKi = dropNguoiKi.SelectedValue;
        //}
        private void LoadLoaiAn()
        {
            dropLoaian.Items.Add(new ListItem("Tất cả", "0"));
            dropLoaian.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            dropLoaian.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            dropLoaian.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            dropLoaian.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            dropLoaian.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            dropLoaian.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            dropLoaian.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
        }

        protected void dropLoaian_SelectedIndexChanged(object sender, EventArgs e)
        {
            var loaiAn = dropLoaian.SelectedValue;
        }

        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;
            LoadLoaiAn();
            //LoadNguoiKi();
            lbthongbao.Text = "";
            //ptT.Visible = ptB.Visible = true;

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vLoaian = Convert.ToDecimal(dropLoaian.SelectedValue);

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            QLCBBA_BL oBL = new QLCBBA_BL();
            int pageSize = Convert.ToInt32(dgList.PageSize), pageIndex = Convert.ToInt32(hddPageIndex.Value);
            //int pageSize = 10, pageIndex = 1;

            var vSoBA = txtBAQD.Text.Trim();

            //DateTime? vNgayBA = DateTime.Now;
            //vNgayBA = (String.IsNullOrEmpty(txtNgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DataTable oDT = oBL.GetQLCBBA(txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(),vLoaian, vSoBA, txtNgayBAQD.Text.Trim(),  vDonViID, dFrom.ToString(), dTo.ToString(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), pageIndex, pageSize);
            //DataTable oDT = oBL.GetQLHS(1, vLoaian, txtNgayBAQD.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vDonViID, txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), pageIndex, pageSize);

            //DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian,   vNgayThuLy.ToString(), vSoBA, vNgayBA.ToString(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon,vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, dFrom.ToString(), dTo.ToString(), Convert.ToDecimal(ddTrangthai.SelectedValue), pageIndex, pageSize);
            int Total = 0;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, Convert.ToInt32(dgList.PageSize)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            }
            
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");


                //var LOAIAN = e.Item.Cells[GetColumnIndexByName(dgList, "TENLOAIAN")].Text.Trim();
                //var ISCONGBOBA = e.Item.Cells[GetColumnIndexByName(dgList, "ISCONGBOBA")].Text.Trim();
                //if (ISCONGBOBA == "0")
                //{
                //    lbtXoa.Visible = false;
                //}
                //if (ISCONGBOBA == "4")
                //{
                //    //lblSua.Text = "Sửa";

                //    //--1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                //    //lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}

                //if (ISCONGBOBA == "1")
                //{
                //    lblSua.Visible = true;
                //    lbtXoa.Visible = true;
                //}


                //if (ISCONGBOBA == "3")
                //{
                //    //--1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}
                //Panel pn_HanhChinh = (Panel)e.Item.FindControl("pn_HanhChinh");
                //Panel pn_DanSu = (Panel)e.Item.FindControl("pn_DanSu");
                //Panel pn_Khac = (Panel)e.Item.FindControl("pn_Khac");

                //pn_HanhChinh.Visible = false;
                //pn_DanSu.Visible = false;
                //pn_Khac.Visible = false;
                //if (!string.IsNullOrEmpty(TENLOAIAN))
                //{
                //    if (int.Parse(TENLOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_HANHCHINH))
                //    {
                //        pn_HanhChinh.Visible = true;
                //    }
                //    if (int.Parse(TENLOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_DANSU))
                //    {
                //        pn_DanSu.Visible = true;
                //    }
                //    else
                //    {
                //        pn_Khac.Visible = true;
                //    }
                //}

            }
        }

        private int GetColumnIndexByName(DataGrid grid, string name)
        {

            for (int i = 0; i < grid.Columns.Count; i++)
            {
                try
                {
                    var item = ((System.Web.UI.WebControls.BoundColumn)grid.Columns[i]).DataField;

                    if (!string.IsNullOrEmpty(item) && item.ToLower().Trim() == name.ToLower().Trim())
                    {
                        return i;
                    }
                }
                catch
                {


                }

            }


            return -1;
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "CongBo":
                    decimal VuViecID = Convert.ToDecimal(e.CommandArgument.ToString());
                    var LOAIAN = e.Item.Cells[GetColumnIndexByName(dgList, "LOAIAN")].Text.Trim();
                    var ISCONGBOBA = e.Item.Cells[GetColumnIndexByName(dgList, "ISCONGBOBA")].Text.Trim();

                    hddVuViecID.Value = "" + VuViecID;
                    break;
            }
        }
        protected void btnLammoi_Click(object sender , EventArgs e)
        {
            ResetControl();
            LoadGrid();
        }
        public void xoa(decimal id)
        {

        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                #region Validate
                #endregion
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {


        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

    }
}

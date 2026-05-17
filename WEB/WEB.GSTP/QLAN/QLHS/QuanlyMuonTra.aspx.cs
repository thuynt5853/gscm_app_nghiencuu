using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.QLHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.QLHS
{
    public partial class QuanlyMuonTra : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {

            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_exels);

            try
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    LoadThamPhan();
                    hddPageIndex.Value = "1";
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadCombobox()
        {
            LoadLoaiAn();
            //--------------------
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
                LoadCapXetXu(ENUM_GIAIDOANVUAN.SOTHAM);
            else
                LoadCapXetXu(ENUM_GIAIDOANVUAN.PHUCTHAM);

        }
        private void LoadCapXetXu(decimal LOAI)
        {
            dropCapxx.Items.Clear();

            if (LOAI == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (LOAI == ENUM_GIAIDOANVUAN.PHUCTHAM)
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));

                var itemphuctham = new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString());
                itemphuctham.Selected = true;
                dropCapxx.Items.Add(itemphuctham);
            }

        }
        private void LoadLoaiAn()
        {
            dropLoaian.Items.Add(new ListItem("Tất cả", "0"));
            dropLoaian.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            dropLoaian.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            dropLoaian.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            dropLoaian.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            dropLoaian.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            dropLoaian.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            dropLoaian.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
        }


        protected void dropLoaian_SelectedIndexChanged(object sender, EventArgs e)
        {
            var loaiAn = dropLoaian.SelectedValue;

            lblNguyenDon.Text = "Nguyên đơn";
            lblBiDon.Text = "Bị đơn";
            if (loaiAn == "01")//Hình sự
            {
                lblNguyenDon.Text = "Bị cáo đầu vụ";
                lblBiDon.Text = "Bị cáo";
            }
        }
        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        private void LoadThamPhan()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);


        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vCapxetxu = Convert.ToDecimal(dropCapxx.SelectedValue);
            decimal vLoaian = Convert.ToDecimal(dropLoaian.SelectedValue);

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            QLHS_BL oBL = new QLHS_BL();
            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
            // DateTime? vNgayThuLy = DateTime.Now; 
            //vNgayThuLy = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            var vSoBA = txtBAQD.Text.Trim();

            //DateTime? vNgayBA = DateTime.Now;
            //vNgayBA = (String.IsNullOrEmpty(txtNgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            var vThamPhanChuToa = txtThamphan.Text.Trim();
            var vThuKy = txtThuky.Text.Trim();
            var vNguyenDon = txtNguyendon.Text.Trim();
            var vBiDon = txtBidon.Text.Trim();

            var listTrangThai = new List<string>();
            listTrangThai.Add("1");
            listTrangThai.Add("3");
            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), listTrangThai, pageIndex, pageSize);

            //DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian,   vNgayThuLy.ToString(), vSoBA, vNgayBA.ToString(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon,vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, dFrom.ToString(), dTo.ToString(), Convert.ToDecimal(ddTrangthai.SelectedValue), pageIndex, pageSize);

            int Total = 0;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            }

            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            if (oDT.Rows.Count == 0)
            {
                cmd_exels.Visible = false;
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


                var LOAIAN = e.Item.Cells[GetColumnIndexByName(dgList, "LOAIAN")].Text.Trim();
                var TRANGTHAIHOSO = e.Item.Cells[GetColumnIndexByName(dgList, "TRANGTHAIHOSO")].Text.Trim();
                if (TRANGTHAIHOSO == "0")
                {
                    lbtXoa.Visible = false;
                }
                if (TRANGTHAIHOSO == "1")
                {
                    //lblSua.Text = "Sửa";

                    //--1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                }


                Panel pn_HanhChinh = (Panel)e.Item.FindControl("pn_HanhChinh");
                Panel pn_DanSu = (Panel)e.Item.FindControl("pn_DanSu");
                Panel pn_Khac = (Panel)e.Item.FindControl("pn_Khac");

                pn_HanhChinh.Visible = false;
                pn_DanSu.Visible = false;
                pn_Khac.Visible = false;
                if (!string.IsNullOrEmpty(LOAIAN))
                {
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_HANHCHINH))
                    {
                        pn_HanhChinh.Visible = true;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_DANSU))
                    {
                        pn_DanSu.Visible = true;
                    }
                    else
                    {
                        pn_Khac.Visible = true;
                    }
                }
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
                case "Sua":

                    decimal IDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
                    var LOAIAN = e.Item.Cells[GetColumnIndexByName(dgList, "LOAIAN")].Text.Trim();
                    var TRANGTHAIHOSO = e.Item.Cells[GetColumnIndexByName(dgList, "TRANGTHAIHOSO")].Text.Trim();
                    var MAGIAIDOAN = e.Item.Cells[GetColumnIndexByName(dgList, "MAGIAIDOAN")].Text.Trim();
                    var SOBANAN = e.Item.Cells[GetColumnIndexByName(dgList, "SOBANAN")].Text.Trim();
                    var NGAYBANAN = e.Item.Cells[GetColumnIndexByName(dgList, "NGAYBANAN")].Text.Trim();
                    hddVuViecID.Value = "" + IDVuViec;
                    hddLoaiAn.Value = LOAIAN;
                    hddCapxx.Value = MAGIAIDOAN;



                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_capnhat('" + "" + IDVuViec + "','" + LOAIAN + "','" + MAGIAIDOAN + "','" + TRANGTHAIHOSO + "','"+SOBANAN+"','"+ NGAYBANAN + "');");

                    //QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == decimal.Parse(hddLoaiAn.Value) && x.CAPXX == decimal.Parse(hddCapxx.Value)).FirstOrDefault();

                    //if (oT != null)
                    //{
                    //    ddNguoinhan.SelectedValue = "" + oT.NGUOINHANID;
                    //    ddlNguoichuyen.SelectedValue = "" + oT.NGUOICHUYENID;

                    //    if (oT.NGAYGIAONHAN.HasValue)
                    //    {
                    //        txtNgaygiao.Text = oT.NGAYGIAONHAN.Value.ToString("dd/MM/yyyy");
                    //    }

                    //}

                    //pnCapnhat.Visible = true;
                    //pnDanhsach.Visible = false;
                    break;

                case "Xoa":

                    decimal dIDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
                    var strLOAIAN = e.Item.Cells[GetColumnIndexByName(dgList, "LOAIAN")].Text.Trim();
                    var dTRANGTHAIHOSO = e.Item.Cells[GetColumnIndexByName(dgList, "TRANGTHAIHOSO")].Text.Trim();
                    var dMAGIAIDOAN = e.Item.Cells[GetColumnIndexByName(dgList, "MAGIAIDOAN")].Text.Trim();

                    hddVuViecID.Value = "" + dIDVuViec;
                    hddLoaiAn.Value = strLOAIAN;
                    hddCapxx.Value = dMAGIAIDOAN;



                    decimal dLOAIAN = decimal.Parse(strLOAIAN);
                    decimal Capxx = decimal.Parse(hddCapxx.Value);

                    QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == dIDVuViec && x.LOAIAN == dLOAIAN && x.CAPXX == Capxx).FirstOrDefault();
                    if (oT != null)
                    {

                        dt.QLHS_STPT.Remove(oT);
                        dt.SaveChanges();
                    }

                    lbthongbao.Text = "Xóa thành công!";
                    LoadGrid();
                    break;
            }
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

        protected void cmdExport_Click(object sender, EventArgs e)
        {
            try
            {

                ExportGridToExcel();
            }
            catch (Exception ex) { }
        }
        protected void cmdExportChuaChuyen_Click(object sender, EventArgs e)
        {
            try
            {

                ExportGridToExcelChuaChuyen();
            }
            catch (Exception ex) { }
        }
        private void ExportGridToExcel()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vCapxetxu = Convert.ToDecimal(dropCapxx.SelectedValue);
            decimal vLoaian = Convert.ToDecimal(dropLoaian.SelectedValue);

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            QLHS_BL oBL = new QLHS_BL();

            var vSoBA = txtBAQD.Text.Trim();


            var vThamPhanChuToa = txtThamphan.Text.Trim();
            var vThuKy = txtThuky.Text.Trim();
            var vNguyenDon = txtNguyendon.Text.Trim();
            var vBiDon = txtBidon.Text.Trim();

            var listTrangThai = new List<string>();
            listTrangThai.Add("1");
            listTrangThai.Add("3");
            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), listTrangThai, 0, 10000000);
            var TRANGTHAI = ddTrangthai.SelectedValue;
            var title = "BÁO CÁO HỒ SƠ";
            if (TRANGTHAI == "0")
            {
                title = "BÁO CÁO HỒ SƠ CHƯA LƯU";
            }
            else if (TRANGTHAI == "1")
            {
                title = "BÁO CÁO HỒ SƠ ĐÃ LƯU";
            }
            else if (TRANGTHAI == "2")
            {
                title = "BÁO CÁO HỒ SƠ PHIẾU MƯỢN";
            }
            else if (TRANGTHAI == "3")
            {
                title = "BÁO CÁO HỒ SƠ ĐÃ CHUYỂN";
            }
            else if (TRANGTHAI == "4")
            {
                title = "BÁO CÁO HỒ SƠ CÓ KHÁNG CÁO";
            }

            var html = "";
            html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";

            html = html + @"<tr>";
            html = html + @"<td colspan='12' style='line-height: 100%; font-size: 18pt; text-align: center; height: 40px;'><b>" + title + "</b></td>";
            html = html + @"</tr>";

            html = html + @"<tr class='header'>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>TT</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Số, ngày thụ lý</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Loại án</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>BA/QĐ</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Tên vụ việc</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Giai đoạn</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Quan hệ QL (Tội danh)</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Thẩm phán</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Thư ký</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Trạng thái</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Ngày chuyển</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Đơn vị chuyển</th>";
            html = html + @" </tr>";


            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                var SOTHULY = "" + oDT.Rows[i]["SOTHULY"];
                var NGAYTHULY = "" + oDT.Rows[i]["NGAYTHULY"];
                var TENLOAIAN = "" + oDT.Rows[i]["TENLOAIAN"];
                var SOBANAN = "" + oDT.Rows[i]["SOBANAN"];
                var NGAYBANAN = "" + oDT.Rows[i]["NGAYBANAN"];
                var TENVUVIEC = "" + oDT.Rows[i]["TENVUVIEC"];
                var GIAIDOANVUVIEC = "" + oDT.Rows[i]["GIAIDOANVUVIEC"];
                var QUANHEPL = "" + oDT.Rows[i]["QUANHEPL"];
                var THAMPHAN = "" + oDT.Rows[i]["THAMPHAN"];
                var THUKY = "" + oDT.Rows[i]["THUKY"];
                var TENTRANGTHAIHOSO = "" ;
                var NGAYGIAONHANHOSO = "" + oDT.Rows[i]["NGAYGIAONHANHOSO"];
                var TENDONVINHANHOSO = "" + oDT.Rows[i]["TENDONVINHANHOSO"];
                TENTRANGTHAIHOSO += Convert.ToInt32(oDT.Rows[i]["TRANGTHAIHOSO"]) == 3 && Convert.ToInt32(oDT.Rows[i]["TRANGTHAIHOSO_LICHSU"]) != 1 ? oDT.Rows[i]["TENTRANGTHAIHOSO"] + "<br/> Ngày: " + oDT.Rows[i]["NGAYGIAONHANHOSO"] + "<br/> Đơn vị nhận: " + oDT.Rows[i]["TENDONVINHANHOSO"] : "" ;
                TENTRANGTHAIHOSO += Convert.ToInt32(oDT.Rows[i]["TRANGTHAIHOSO_LICHSU"]) == 1 ? "Có phiếu mượn"
                          + "<br/> Ngày: " + oDT.Rows[i]["NGAYGIAONHANHOSO"]
                          + "<br/> Đơn vị mượn: " + oDT.Rows[i]["TENDONVINHANHOSO"]

                          : "";
                TENTRANGTHAIHOSO += Convert.ToInt32(oDT.Rows[i]["TRANGTHAIHOSO"]) == 1 && Convert.ToInt32(oDT.Rows[i]["TRANGTHAIHOSO_LICHSU"]) != 1 ? oDT.Rows[i]["TENTRANGTHAIHOSO"]
                        : "";

                html = html + @"<tr class='chan'>";
                html = html + @" <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + SOTHULY + " <br style='mso-data-placement:same-cell;' /> " + NGAYTHULY + " </td>";

                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + TENLOAIAN + "</td>";
                html = html + @" <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + SOBANAN + " <br style='mso-data-placement:same-cell;' /> " + NGAYBANAN + "</td>";

                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + TENVUVIEC + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + GIAIDOANVUVIEC + "</td> ";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + QUANHEPL + "</td> ";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + THAMPHAN + "</td> ";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + THUKY + "</td> ";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: left; vertical-align: middle;'>" + TENTRANGTHAIHOSO + "</td> ";
                html = html + @"  <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + NGAYGIAONHANHOSO + "</td> ";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + TENDONVINHANHOSO + "</td> ";

                html = html + @"</tr> ";

            }



            html = html + @"<table>";

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=QUANLYHOSO_STPT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

            Response.Write(html);
            try
            {
                Response.End();
            }
            catch
            {


            }
        }


        private void ExportGridToExcelChuaChuyen()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vCapxetxu = Convert.ToDecimal(dropCapxx.SelectedValue);
            decimal vLoaian = Convert.ToDecimal(dropLoaian.SelectedValue);

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            QLHS_BL oBL = new QLHS_BL();

            var vSoBA = txtBAQD.Text.Trim();


            var vThamPhanChuToa = txtThamphan.Text.Trim();
            var vThuKy = txtThuky.Text.Trim();
            var vNguyenDon = txtNguyendon.Text.Trim();
            var vBiDon = txtBidon.Text.Trim();

            var listTrangThai = new List<string>();
            listTrangThai.Add("1");
            listTrangThai.Add("3");
            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), listTrangThai, 0, 10000000);

            var html = "";
            html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";
            html = html + @"<tr class='header'>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>TT</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Số, ngày thụ lý</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Loại án</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>BA/QĐ</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Tên vụ việc</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Giai đoạn</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Quan hệ QL (Tội danh)</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Thẩm phán</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Thư ký</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Trạng thái</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Ngày chuyển</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Đơn vị chuyển</th>";
            html = html + @" </tr>";


            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                var SOTHULY = "" + oDT.Rows[i]["SOTHULY"];
                var NGAYTHULY = "" + oDT.Rows[i]["NGAYTHULY"];
                var TENLOAIAN = "" + oDT.Rows[i]["TENLOAIAN"];
                var SOBANAN = "" + oDT.Rows[i]["SOBANAN"];
                var NGAYBANAN = "" + oDT.Rows[i]["NGAYBANAN"];
                var TENVUVIEC = "" + oDT.Rows[i]["TENVUVIEC"];
                var GIAIDOANVUVIEC = "" + oDT.Rows[i]["GIAIDOANVUVIEC"];
                var QUANHEPL = "" + oDT.Rows[i]["QUANHEPL"];
                var THAMPHAN = "" + oDT.Rows[i]["THAMPHAN"];
                var THUKY = "" + oDT.Rows[i]["THUKY"];
                var TENTRANGTHAIHOSO = "" + oDT.Rows[i]["TENTRANGTHAIHOSO"];
                var NGAYGIAONHANHOSO = "" + oDT.Rows[i]["NGAYGIAONHANHOSO"];
                var TENDONVINHANHOSO = "" + oDT.Rows[i]["TENDONVINHANHOSO"];


                html = html + @"<tr class='chan'>";
                html = html + @" <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + SOTHULY + " <br style='mso-data-placement:same-cell;' /> " + NGAYTHULY + " </td>";

                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + TENLOAIAN + "</td>";
                html = html + @" <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + SOBANAN + " <br style='mso-data-placement:same-cell;' /> " + NGAYBANAN + "</td>";

                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'> " + TENVUVIEC + "</td>";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + GIAIDOANVUVIEC + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + QUANHEPL + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + THAMPHAN + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + THUKY + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + TENTRANGTHAIHOSO + "</td> ";
                html = html + @"  <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + NGAYGIAONHANHOSO + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + TENDONVINHANHOSO + "</td> ";

                html = html + @"</tr> ";

            }



            html = html + @"<table>";

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=QUANLYHOSO_STPT.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

            Response.Write(html);
            try
            {
                Response.End();
            }
            catch
            {


            }
        }
    }
}
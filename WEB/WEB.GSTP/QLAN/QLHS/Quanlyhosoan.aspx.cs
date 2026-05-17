using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.QLHS;
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

namespace WEB.GSTP.QLAN.QLHS
{
    public partial class Quanlyhosoan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_exels);
            scriptManager.RegisterPostBackControl(this.cmd_exelDanhSach);
            try
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    LoadThamPhan();
                    hddPageIndex.Value = "1";
                    //LoadGrid();
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

            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), pageIndex, pageSize);

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
                if (TRANGTHAIHOSO == "4")
                {
                    //lblSua.Text = "Sửa";

                    //--1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                    //lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                if (TRANGTHAIHOSO == "1")
                {
                    lblSua.Visible = true;
                    lbtXoa.Visible = true;
                }


                if (TRANGTHAIHOSO == "3")
                {
                    //--1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
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

                    hddVuViecID.Value = "" + IDVuViec;
                    hddLoaiAn.Value = LOAIAN;
                    hddCapxx.Value = MAGIAIDOAN;



                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_capnhat('" + "" + IDVuViec + "','" + LOAIAN + "','" + MAGIAIDOAN + "','" + TRANGTHAIHOSO + "');");


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

        protected void cmdExport_Click(object sender, EventArgs e)
        {
            try
            {
                if(ddTrangthai.SelectedValue == "-1")
                {
                    lbthongbao.Text = "Hãy chọn trạng thái hồ sơ!";
                    return;
                }
                if (dropLoaian.SelectedValue == "0")
                {
                    lbthongbao.Text = "Hãy chọn loại án!";
                    return;
                }

                ExportGridToExcel();
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

            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), 0, 1000000);




            List<Export> lstExportData = new List<Export>();
            List<Export> lstExport = new List<Export>();
            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                
                //NGAYTHULY dd/MM/yyyy
                var NGAYTHULY = "" + oDT.Rows[i]["NGAYTHULY"];
                var LOAIAN = "" + oDT.Rows[i]["LOAIAN"];
                if (!string.IsNullOrEmpty(NGAYTHULY) && !string.IsNullOrEmpty(LOAIAN))
                {
                    Export export = new Export();
                    var arrNgayThuLy = NGAYTHULY.Split('/');
                    export.YEAR = int.Parse(arrNgayThuLy[2]);


                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_HINHSU))
                    {
                        export.HINHSU = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_DANSU))
                    {
                        export.DANSU = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH))
                    {
                        export.HONNHAN = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI))
                    {
                        export.KINHDOANH = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_LAODONG))
                    {
                        export.LAODONG = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_HANHCHINH))
                    {
                        export.HANHCHINH = 1;
                    }
                    if (int.Parse(LOAIAN) == int.Parse(ENUM_LOAIVUVIEC.AN_PHASAN))
                    {
                        export.PHASAN = 1;
                    }
                    lstExport.Add(export);
                }
            }
            if (lstExport.Count > 0)
            {

                lstExportData = lstExport.GroupBy(t => t.YEAR)
                          .Select(t => new Export
                          {
                              YEAR = t.Key,
                              COUNT_DANSU = t.Sum(ta => ta.DANSU),
                              COUNT_HINHSU = t.Sum(ta => ta.HINHSU),
                              COUNT_HANHCHINH = t.Sum(ta => ta.HANHCHINH),
                              COUNT_HONNHAN = t.Sum(ta => ta.HONNHAN),
                              COUNT_KINHDOANH = t.Sum(ta => ta.KINHDOANH),
                              COUNT_LAODONG = t.Sum(ta => ta.LAODONG),
                              COUNT_PHASAN = t.Sum(ta => ta.PHASAN),
                          }).ToList();


            }
            for (int i = 0; i < lstExportData.Count; i++)
            {


                lstExportData[i].TONGCONG = lstExportData[i].COUNT_DANSU + lstExportData[i].COUNT_HINHSU + lstExportData[i].COUNT_HANHCHINH + lstExportData[i].COUNT_HONNHAN + lstExportData[i].COUNT_KINHDOANH + lstExportData[i].COUNT_LAODONG + lstExportData[i].COUNT_PHASAN;
            }

            var minYear = 0;
            var maxYear = 0;

            if (lstExportData.Count > 0)
            {
                lstExportData = lstExportData.OrderByDescending(t => t.YEAR).ToList();

                minYear = lstExportData.Select(t => t.YEAR).Min();
                maxYear = lstExportData.Select(t => t.YEAR).Max();
            }

            var title = "BÁO CÁO HỒ SƠ";

            //<asp:DropDownList ID="ddTrangthai" CssClass="chosen-select" runat="server" Width="157px">
            //                                          <asp:ListItem Value="-1" Text="Tất cả" Selected="True"></asp:ListItem>
            //                                          <asp:ListItem Value="0" Text="Chưa lưu"></asp:ListItem>
            //                                          <asp:ListItem Value="1" Text="Đã lưu"></asp:ListItem>
            //                                          <asp:ListItem Value="2" Text="Có phiếu mượn"></asp:ListItem>

            //                                          <asp:ListItem Value="3" Text="Đã chuyển"></asp:ListItem>
            //                                          <asp:ListItem Value="4" Text="Có kháng cáo"></asp:ListItem>
            //                                      </asp:DropDownList>

            var TRANGTHAI = ddTrangthai.SelectedValue;
            if (TRANGTHAI=="0")
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
            
           
            if (minYear > 0 && maxYear > 0)
            {
                if (minYear != maxYear)
                {
                    title = title + " " + minYear + " - " + maxYear;
                }
                else
                    title = title + " " + minYear;
            }

            //fill data
            var html = "";
            html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";

            html = html + @"<tr>";
            html = html + @"<td colspan='4' style='text-align: center; vertical-align: top; font-size: 11pt'>TÒA ÁN NHÂN DÂN TỐI CAO</td>";
            //html = html + @"<td colspan='2'></td>";
            html = html + @"<th colspan='5' style='text-align: center; vertical-align: top; font-size: 11pt;'>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>";
            html = html + @"</tr>";
            html = html + @"<tr style='text-align: center;'>";
            html = html + @"<th colspan='4' style='vertical-align: top; font-size: 11pt;'>" + Session[ENUM_SESSION.SESSION_TENDONVI] + "</th>";
            //html = html + @"<td colspan='2'></td>";
            html = html + @"<th colspan='5' style='vertical-align: top; font-size: 13pt;'>Độc lập - Tự do - Hạnh phúc </th>";
            html = html + @"</tr>";

            html = html + @"<tr>";
            html = html + @"   <td colspan='9' style='height:8px;'></td>";
            html = html + @"</tr>";

            html = html + @"<tr>";
            html = html + @"<td colspan='9' style='line-height: 100%; font-size: 13pt; text-align: center; height: 26px;'><b>"+ title + "</b></td>";
            html = html + @"</tr>";

            html = html + @"<tr>";
            html = html + @"   <td colspan='9' style='height:13px;'></td>";
            html = html + @"</tr>";

            html = html + @"<tr class='header'>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>TT</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Năm</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Hình sự</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Dân sự</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Kinh tế</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Hành chính</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Hôn nhân</th>";
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Lao động</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Tổng cộng</th>";
            html = html + @" </tr>";

            for (int i = 0; i < lstExportData.Count; i++)
            {

                var item = lstExportData[i];



                html = html + @"<tr class='chan'>";
                html = html + @" <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";

                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.YEAR + "</td>";

                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_HINHSU + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_DANSU + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_KINHDOANH + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_HANHCHINH + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_HONNHAN + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.COUNT_LAODONG + "</td>";
                html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + item.TONGCONG + "</td>";

                html = html + @"</tr> ";

            }



            html = html + @"<tr>";
            html = html + @"   <td colspan='9' style='height:13px;'></td>";
            html = html + @"</tr>";
            html = html + @"<tr>";
            html = html + @"    <td colspan='3' style='height: 100px; vertical-align: top; text-align: center; font-weight: bold;'>Phó trưởng phòng lưu trữ hồ sơ";
            html = html + @"   </td>";
            //html = html + @"    <td colspan='3' style='height: 100px; vertical-align: top; text-align: center'></td>";
            html = html + @"   <td colspan='6' style='height: 100px; vertical-align: top; text-align: center; font-weight: bold;'>Người làm báo cáo</td>";
            html = html + @"</tr>";
            html = html + @"<tr>";
            html = html + @"    <td colspan='3' style='vertical-align: top; text-align: center; font-weight: bold;font-size: 12pt;'> </td>";
            //html = html + @"    <td colspan='3' style='vertical-align: top; text-align: center'></td>";
            html = html + @"    <td colspan='6' style='vertical-align: top; text-align: center; font-weight: bold;font-size: 12pt;'>"+ Session[ENUM_SESSION.SESSION_USERTEN] + "</td>";
            html = html + @"</tr>"; 
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

        protected void cmdExportData_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddTrangthai.SelectedValue == "-1")
                {
                    lbthongbao.Text = "Hãy chọn trạng thái hồ sơ!";
                    return;
                }
                if (dropLoaian.SelectedValue == "0")
                {
                    lbthongbao.Text = "Hãy chọn loại án!";
                    return;
                }

                ExportGridToExcelData();
            }
            catch (Exception ex) { }
        }

        private void ExportGridToExcelData()
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
            //listTrangThai.Add("1");
            //listTrangThai.Add("3");
            DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), 0, 10000000);
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
            html = html + @"<td colspan='12' style='line-height: 100%; font-size: 13pt; text-align: center; height: 40px;'><b>" + title + "</b></td>";
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
            html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Trạng thái</th>";
            html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 40px;'>Ngày chuyển/ngày lưu</th>";
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
                var TENTRANGTHAIHOSO = Convert.ToInt32("" + oDT.Rows[i]["TRANGTHAIHOSO"]) == 3 ? "" + oDT.Rows[i]["TENTRANGTHAIHOSO"]
                                                                   + "<br/> Ngày: " + "" + oDT.Rows[i]["NGAYGIAONHANHOSO"]
                                                                   + "<br/> Đơn vị nhận: " + "" + oDT.Rows[i]["TENDONVINHANHOSO"]

                                                                   : "" + oDT.Rows[i]["TENTRANGTHAIHOSO"];
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
                html = html + @"   <td style='border: 1pt solid Black; text-align: left; vertical-align: middle;'>" + TENTRANGTHAIHOSO + "</td> ";
                html = html + @"  <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + NGAYGIAONHANHOSO + "</td> ";
                html = html + @"   <td style='border: 1pt solid Black; text-align: center; vertical-align: middle;'>" + TENDONVINHANHOSO + "</td> ";

                html = html + @"</tr> ";

            }



            html = html + @"<table>";

            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DANHSACH_QUANLYHOSO_STPT.xls");
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
        //private void ExportGridToExcel()
        //{
        //    decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    decimal vCapxetxu = Convert.ToDecimal(dropCapxx.SelectedValue);
        //    decimal vLoaian = Convert.ToDecimal(dropLoaian.SelectedValue);

        //    DateTime? dFrom = DateTime.Now;
        //    DateTime? dTo = DateTime.Now;
        //    dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

        //    QLHS_BL oBL = new QLHS_BL();

        //    var vSoBA = txtBAQD.Text.Trim();

        //    var vThamPhanChuToa = txtThamphan.Text.Trim();
        //    var vThuKy = txtThuky.Text.Trim();
        //    var vNguyenDon = txtNguyendon.Text.Trim();
        //    var vBiDon = txtBidon.Text.Trim();

        //    DataTable oDT = oBL.GetQLHS(vCapxetxu, vLoaian, txtNgaythuly.Text.Trim(), vSoBA, txtNgayBAQD.Text.Trim(), vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Convert.ToDecimal(ddTrangthai.SelectedValue), new List<string>(), 0, 1000000);


        //    var html = "";
        //    html = html + @"<table cellpadding='0' cellspacing='1' style='font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;'>";
        //    html = html + @"<tr class='header'>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>TT</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Số, ngày thụ lý</th>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Loại án</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>BA/QĐ</th>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Tên vụ việc</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Giai đoạn</th>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Quan hệ QL (Tội danh)</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Thẩm phán</th>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Thư ký</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Trạng thái</th>";
        //    html = html + @" <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Ngày chuyển</th>";
        //    html = html + @"   <th style='text-align: center; vertical-align: middle; border: 0.1pt solid Black;'>Đơn vị chuyển</th>";
        //    html = html + @" </tr>";


        //    for (int i = 0; i < oDT.Rows.Count; i++)
        //    {
        //        var SOTHULY = "" + oDT.Rows[i]["SOTHULY"];
        //        var NGAYTHULY = "" + oDT.Rows[i]["NGAYTHULY"];
        //        var TENLOAIAN = "" + oDT.Rows[i]["TENLOAIAN"];
        //        var SOBANAN = "" + oDT.Rows[i]["SOBANAN"];
        //        var NGAYBANAN = "" + oDT.Rows[i]["NGAYBANAN"];
        //        var TENVUVIEC = "" + oDT.Rows[i]["TENVUVIEC"];
        //        var GIAIDOANVUVIEC = "" + oDT.Rows[i]["GIAIDOANVUVIEC"];
        //        var QUANHEPL = "" + oDT.Rows[i]["QUANHEPL"];
        //        var THAMPHAN = "" + oDT.Rows[i]["THAMPHAN"];
        //        var THUKY = "" + oDT.Rows[i]["THUKY"];
        //        var TENTRANGTHAIHOSO = "" + oDT.Rows[i]["TENTRANGTHAIHOSO"];
        //        var NGAYGIAONHANHOSO = "" + oDT.Rows[i]["NGAYGIAONHANHOSO"];
        //        var TENDONVINHANHOSO = "" + oDT.Rows[i]["TENDONVINHANHOSO"];


        //        html = html + @"<tr class='chan'>";
        //        html = html + @" <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + (i + 1) + "</td>";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + SOTHULY + " <br style='mso-data-placement:same-cell;' /> " + NGAYTHULY + " </td>";

        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + TENLOAIAN + "</td>";
        //        html = html + @" <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + SOBANAN + " <br style='mso-data-placement:same-cell;' /> " + NGAYBANAN + "</td>";

        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'> " + TENVUVIEC + "</td>";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + GIAIDOANVUVIEC + "</td> ";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + QUANHEPL + "</td> ";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + THAMPHAN + "</td> ";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + THUKY + "</td> ";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + TENTRANGTHAIHOSO + "</td> ";
        //        html = html + @"  <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + NGAYGIAONHANHOSO + "</td> ";
        //        html = html + @"   <td style='border: 0.1pt solid Black; text-align: center; vertical-align: middle;'>" + TENDONVINHANHOSO + "</td> ";

        //        html = html + @"</tr> ";

        //    }



        //    html = html + @"<table>";

        //    Response.Clear();
        //    Response.AddHeader("content-disposition", "attachment;filename=QUANLYHOSO_STPT.xls");
        //    Response.Cache.SetCacheability(HttpCacheability.NoCache);
        //    Response.ContentType = "application/vnd.xls";
        //    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        //    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        //    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");

        //    Response.Write(html);
        //    try
        //    {
        //        Response.End();
        //    }
        //    catch
        //    {


        //    }
        //}
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
    }



    public class Export
    {
        public int YEAR { get; set; }
        public int DANSU { get; set; }
        public int HINHSU { get; set; }
        public int HANHCHINH { get; set; }
        public int HONNHAN { get; set; }
        public int KINHDOANH { get; set; }
        public int LAODONG { get; set; }
        public int PHASAN { get; set; }
        public int COUNT_DANSU { get; set; }
        public int COUNT_HINHSU { get; set; }
        public int COUNT_HANHCHINH { get; set; }
        public int COUNT_HONNHAN { get; set; }
        public int COUNT_KINHDOANH { get; set; }
        public int COUNT_LAODONG { get; set; }
        public int COUNT_PHASAN { get; set; }
        public int TONGCONG { get; set; }
    }
}
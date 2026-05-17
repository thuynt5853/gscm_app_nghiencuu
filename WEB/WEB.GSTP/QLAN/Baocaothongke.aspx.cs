using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using BL.GSTP.ADS;
using System.Text;

namespace WEB.GSTP.QLAN
{
    public partial class Baocaothongke : System.Web.UI.Page
    {
        //--------------------------------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txtThuly_Tu.Text = strDate;
                txtThuly_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");
                Bao_Cao_permi();
                Load_drop_cbtk();
                Load_Drop_ld_phong();
                LoadDonViTrucThuoc();
                LoadTatCaLoaiAn();
                InitThamPhanEmpty();
                LoadThamPhan();
                ddlThamphan.Enabled = true;
            }
        }
        protected void myListDropDown_Change(object sender, EventArgs e)
        {
            string selectedReport = (ddl_menu_bc.SelectedValue ?? string.Empty).Trim();

            string selectedVal = ddl_menu_bc.SelectedValue.Trim().ToLower();
            // BCPT_04: mặc định lấy tất cả thẩm phán, nhưng vẫn cho phép chọn để lọc.
            ddlThamphan.Enabled = true;
            ddlLoaiAn.Enabled = false;

            try
            {
                ddlThamphan.ClearSelection();

                // RIÊNG BIỂU bcpt_06: mặc định chọn thẩm phán đầu tiên
                if (selectedVal == "bcpt_06")
                {
                    // bỏ "Tất cả" nếu còn
                    ListItem itemAll = ddlThamphan.Items.FindByValue("0");
                    if (itemAll != null)
                    {
                        ddlThamphan.Items.Remove(itemAll);
                    }

                    // chọn thẩm phán đầu tiên
                    if (ddlThamphan.Items.Count > 0)
                    {
                        ddlThamphan.SelectedIndex = 0;
                    }
                }
                else
                {
                    LoadThamPhan();
                    // CÁC BIỂU KHÁC: giữ logic cũ → chọn "Tất cả"
                    if (ddlThamphan.Items.FindByValue("0") != null)
                    {
                        ddlThamphan.SelectedValue = "0";
                    }
                }
            }
            catch
            {
                // ignore – keep current selection
            }

        }


        private string GetPostedDropDownValue(DropDownList ddl)
        {
            // With some client-side enhancers (chosen/select2) or UpdatePanel, SelectedValue can be stale.
            // Prefer the posted form value when available.
            string posted = Request?.Form?[ddl.UniqueID];

            // Fallback: in some layouts the posted key can match ClientID.
            if (string.IsNullOrEmpty(posted))
            {
                posted = Request?.Form?[ddl.ClientID];
            }

            posted = (posted ?? string.Empty).Trim();
            return string.IsNullOrEmpty(posted) ? (ddl.SelectedValue ?? string.Empty).Trim() : posted;
        }

        private const string LOAI_AN_TAT_CA = "0";

        private void LoadThamPhan()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal phongbanId = 0;
            string postedPhongBan = GetPostedDropDownValue(ddlPhongban);
            if (!string.IsNullOrWhiteSpace(postedPhongBan))
            {
                decimal.TryParse(postedPhongBan, out phongbanId);
            }

            DataTable oCBDT = phongbanId > 0
                ? oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH_PHONGBAN(donviId, phongbanId, ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                : oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(donviId, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlThamphan.SelectedIndex = 0;



        }
        private HashSet<string> GetThamPhanNamesByPhongBan(decimal phongbanId)
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DataTable oCBDT = phongbanId > 0
                ? oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH_PHONGBAN(donviId, phongbanId, ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                : oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(donviId, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);

            HashSet<string> names = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow row in oCBDT.Rows)
            {
                string name = (row["HOTEN"] + "").Trim();
                if (!string.IsNullOrWhiteSpace(name))
                {
                    names.Add(name);
                }
            }

            return names;
        }
        private string ExtractNthCellText(string rowHtml, int nth)
        {
            if (string.IsNullOrEmpty(rowHtml) || nth <= 0)
            {
                return string.Empty;
            }

            int count = 0;
            int idx = 0;
            while (idx >= 0 && idx < rowHtml.Length)
            {
                int tdStart = rowHtml.IndexOf("<td", idx, StringComparison.OrdinalIgnoreCase);
                if (tdStart < 0) return string.Empty;

                int tdOpenEnd = rowHtml.IndexOf(">", tdStart, StringComparison.OrdinalIgnoreCase);
                if (tdOpenEnd < 0) return string.Empty;

                int tdClose = rowHtml.IndexOf("</td>", tdOpenEnd, StringComparison.OrdinalIgnoreCase);
                if (tdClose < 0) return string.Empty;

                count++;
                if (count == nth)
                {
                    return rowHtml.Substring(tdOpenEnd + 1, tdClose - tdOpenEnd - 1);
                }

                idx = tdClose + 5;
            }

            return string.Empty;
        }
        private string FilterReportByJudge(string html, HashSet<string> allowedNames)
        {
            if (string.IsNullOrWhiteSpace(html) || allowedNames == null || allowedNames.Count == 0)
            {
                return html;
            }

            HashSet<string> normalizedAllowed = new HashSet<string>(
                allowedNames.Select(NormalizeName),
                StringComparer.OrdinalIgnoreCase
            );

            int firstTableStart = html.IndexOf("<table", StringComparison.OrdinalIgnoreCase);
            if (firstTableStart < 0) return html;

            int firstTableEnd = html.IndexOf("</table>", firstTableStart, StringComparison.OrdinalIgnoreCase);
            if (firstTableEnd < 0) return html;
            firstTableEnd += 8;

            int secondTableStart = html.IndexOf("<table", firstTableEnd, StringComparison.OrdinalIgnoreCase);
            if (secondTableStart < 0) return html;

            int secondTableEnd = html.IndexOf("</table>", secondTableStart, StringComparison.OrdinalIgnoreCase);
            if (secondTableEnd < 0) return html;
            secondTableEnd += 8;

            string secondTable = html.Substring(secondTableStart, secondTableEnd - secondTableStart);

            int firstTr = secondTable.IndexOf("<tr", StringComparison.OrdinalIgnoreCase);
            if (firstTr < 0) return html;

            int lastTrEnd = secondTable.LastIndexOf("</tr>", StringComparison.OrdinalIgnoreCase);
            if (lastTrEnd < 0) return html;

            string tablePrefix = secondTable.Substring(0, firstTr);
            string tableSuffix = secondTable.Substring(lastTrEnd + 5);

            List<string> rows = new List<string>();
            int pos = firstTr;
            while (pos >= 0 && pos < secondTable.Length)
            {
                int trStart = secondTable.IndexOf("<tr", pos, StringComparison.OrdinalIgnoreCase);
                if (trStart < 0 || trStart > lastTrEnd) break;

                int trEnd = secondTable.IndexOf("</tr>", trStart, StringComparison.OrdinalIgnoreCase);
                if (trEnd < 0) break;

                rows.Add(secondTable.Substring(trStart, trEnd + 5 - trStart));
                pos = trEnd + 5;
            }

            List<string> kept = new List<string>();
            foreach (string row in rows)
            {
                if (row.IndexOf("Thẩm phán", StringComparison.OrdinalIgnoreCase) >= 0
                    || row.IndexOf("background-color:#FF0000", StringComparison.OrdinalIgnoreCase) >= 0
                    || row.IndexOf("background-color:#70AD47", StringComparison.OrdinalIgnoreCase) >= 0
                    || row.IndexOf(">TỔNG<", StringComparison.OrdinalIgnoreCase) >= 0
                    || row.IndexOf(">TONG<", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    kept.Add(row);
                    continue;
                }

                string rawName = ExtractNthCellText(row, 2);
                string judgeName = NormalizeName(rawName);

                if (!string.IsNullOrWhiteSpace(judgeName) && normalizedAllowed.Contains(judgeName))
                {
                    kept.Add(row);
                }
            }

            string filteredTable = tablePrefix + string.Join(string.Empty, kept) + tableSuffix;
            return html.Substring(0, secondTableStart) + filteredTable + html.Substring(secondTableEnd);
        }
        private static string NormalizeName(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
            {
                return string.Empty;
            }

            string decoded = HttpUtility.HtmlDecode(input) ?? string.Empty;
            string trimmed = decoded.Trim();

            int dashIndex = trimmed.IndexOf(" - ", StringComparison.Ordinal);
            if (dashIndex > 0)
            {
                trimmed = trimmed.Substring(0, dashIndex).Trim();
            }

            int parenIndex = trimmed.IndexOf("(", StringComparison.Ordinal);
            if (parenIndex > 0)
            {
                trimmed = trimmed.Substring(0, parenIndex).Trim();
            }

            return string.Join(" ", trimmed.Split(new[] { ' ', '\t', '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries));
        }
        private void InitThamPhanEmpty()
        {
            ddlThamphan.Items.Clear();
            ddlThamphan.Items.Insert(0, new ListItem("--- Chọn đơn vị ---", ""));
            ddlThamphan.SelectedIndex = 0;
            ddlThamphan.Enabled = false;
        }
        protected void Load_drop_cbtk()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.DM_CANBO_GETALL(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            drop_cbtk.DataSource = tbl;
            drop_cbtk.DataTextField = "MA_TEN";
            drop_cbtk.DataValueField = "ID";
            drop_cbtk.DataBind();
            drop_cbtk.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        protected void Load_Drop_ld_phong()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.DM_CANBO_GETALL(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Drop_ld_phong.DataSource = tbl;
            Drop_ld_phong.DataTextField = "MA_TEN";
            Drop_ld_phong.DataValueField = "ID";
            Drop_ld_phong.DataBind();
            Drop_ld_phong.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        private void LoadDonViTrucThuoc()
        {
            ddlPhongban.Items.Clear();
            decimal donViId = 0;
            if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
            {
                decimal.TryParse(Session[ENUM_SESSION.SESSION_DONVIID] + "", out donViId);
            }

            if (donViId > 0)
            {
                DM_TOAAN obta = dt.DM_TOAAN.Where(x => x.ID == donViId).FirstOrDefault();
                if (obta != null && obta.LOAITOA == "CAPTINH")
                {
                    ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
                }
                else
                {
                    ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == donViId && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
                }
                ddlPhongban.DataTextField = "TENPHONGBAN";
                ddlPhongban.DataValueField = "ID";
                ddlPhongban.DataBind();
            }

            ddlPhongban.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadDropLoaiAn()
        {
            //Decimal ChucVuPCA = 0;
            //try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }

            Boolean IsLoadAll = false;
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC")
                {
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
                        else if (oCD.MA == "PCA")
                            LoadLoaiAnPhuTrach(oCB);
                    }
                    else
                        IsLoadAll = true;
                    if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {
                    if (obj != null)
                    {
                        if (obj.ISHINHSU == 1)
                        {
                            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                        }
                        LoadLoaiAnPhuTrach_TheoPB(obj);
                    }
                }
            }

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }
        void LoadTatCaLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Add(new ListItem("BP XLHC", ENUM_LOAIVUVIEC.BPXLHC));
            ddlLoaiAn.Enabled = false;

        }

        void LoadLoaiAnPhuTrach_TheoPB(DM_PHONGBAN obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
        }
        void LoadLoaiAnPhuTrach(DM_CANBO obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            }
        }
        void Bao_Cao_permi()
        {
            GDTTT_APP_BL obj_M = new GDTTT_APP_BL();
            DataTable objs = obj_M.Permi_Add_BC(Request.FilePath.ToString(), Convert.ToDecimal(Session["UserID"]));
            ddl_menu_bc.DataSource = objs;
            ddl_menu_bc.DataTextField = "TENMENU";
            ddl_menu_bc.DataValueField = "MAACTION";
            ddl_menu_bc.DataBind();
        }
        protected void btn_NhapMoi_Click(object sender, EventArgs e)
        {
            txtThuly_Tu.Text = string.Empty;
            txtThuly_Den.Text = string.Empty;
            drop_cbtk.SelectedValue = string.Empty;
            Drop_ld_phong.SelectedValue = string.Empty;
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            if (txtThuly_Tu.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập từ ngày.";
                return;
            }
            if (txtThuly_Den.Text == "")
            {
                lblmsg.Text = "Bạn phải nhập đến ngày.";
                return;
            }
            try
            {
                string selectedReport = (ddl_menu_bc.SelectedValue ?? string.Empty).Trim();
                switch (selectedReport)
                {
                    case "bcpt_01":
                        LoadReport_bcpt_1();//Tổng hợp số liệu xét xử của các tòa chuyên trách
                        break;
                    case "bcpt_02":
                        LoadReport_bcpt_2();//Thống kê tình hình thụ lý, giải quyết xét xử theo trình tự phúc thẩm các loại vụ, việc
                        break;
                    case "bcpt_03":
                        LoadReport_bcpt_3();//Kết quả thụ lý và giải quyết phúc thẩm án các loại
                        break;
                    //vnpt_8/1/2026
                    case "bcpt_04":
                        LoadReport_bcpt_4();//Biểu mẫu thống kê các toà chuyên trách
                        break;
                    case "bcpt_05":
                        LoadReport_bcpt_5();//Thống kê tổng hợp số liệu các loại án theo đơn vị
                        break;
                    case "bcpt_06":
                        LoadReport_bcpt_6(); //Kết quả thụ lý và giải quyết phúc thẩm án các loại theo thẩm phán
                        break;
                    /////
                    case "bctk_hctp":
                        LoadReport_bctk_hctp();//Thống kê tổng hợp số liệu các loại án theo thẩm phán
                        break;
                    case ENUM_BAOCAO_THONGKE.BAOCAOCHITIEUVEDONTHEOKY_THAMPHAN:
                        LoadReport_bctk_ttp();//báo cáo thống kê theo thẩm phán
                        break;
                    case ENUM_BAOCAO_THONGKE.BAOCAOCHITIEUVEDONTHEOKY_LOAIAN:
                        LoadReport_bctk_tla();//báo cáo thống kê theo loại án
                        break;
                        //default:
                        //    break;
                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private bool CheckData()
        {
            string TuNgay = txtThuly_Tu.Text, DenNgay = txtThuly_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtThuly_Tu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtThuly_Den.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }
            }
            return true;
        }
        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
        private void LoadReport_bcpt_1()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Tong_hop_so_lieu_xx(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), ddlLoaiAn.SelectedValue);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Tonghop_solieu_xx.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }

        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadThamPhan();
            ddlThamphan.Enabled = true;
        }
        private void LoadReport_bctk_ttp()
        {
            try
            {
                if (ddlThamphan.SelectedValue == "0")
                {
                    lblmsg.Text = "Bạn phải chọn thẩm phán.";
                    return;
                }
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Thongke_TTP(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(ddlThamphan.SelectedValue), txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), Session["CAP_XET_XU"] + "");
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thongke_TTP.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bctk_tla()
        {
            try
            {

                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Thongke_TLA(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ddlLoaiAn.SelectedValue, ddlLoaiAn.SelectedItem.Text, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), Session["CAP_XET_XU"] + "");
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thongke_TLA.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bctk_hctp()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.Thongke_HCTP(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN, txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), ddlLoaiAn.SelectedValue, Session["CAP_XET_XU"] + "");
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thongke_HCTP.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_2()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.TL_XX_TRINHTU_PT_EXPORT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), ddlLoaiAn.SelectedValue);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=TL_trinhtu_pt.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_3()
        {
            try
            {
                lblmsg.Text = "Báo cáo đang được cập nhật.";
                return;
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_4()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                Literal Table_Str_Totals = new Literal();
                // bcpt_04: báo cáo toàn bộ loại án => phải gọi 1 lần từ DB (không loop/ghép HTML theo loại án ở Web).
                try
                {
                    DataTable tblAll;
                    string selectedThamPhan = GetPostedDropDownValue(ddlThamphan);
                    string selectedPhongBan = GetPostedDropDownValue(ddlPhongban);
                    decimal phongBanId = 0;
                    if (!string.IsNullOrWhiteSpace(selectedPhongBan))
                    {
                        decimal.TryParse(selectedPhongBan, out phongBanId);
                    }
                    if (!string.IsNullOrEmpty(selectedThamPhan) && selectedThamPhan != "0")
                    {
                        tblAll = oBL.TK_CACTOA_CHUYENTRACH_THEO_THAMPHAN(
                            drop_cbtk.SelectedValue,
                            Drop_ld_phong.SelectedValue,
                            Session["CAP_XET_XU"] + "",
                            Session[ENUM_SESSION.SESSION_DONVIID] + "",
                            txtThuly_Tu.Text.Trim(),
                            txtThuly_Den.Text.Trim(),
                            Convert.ToDecimal(selectedThamPhan),
                            phongBanId
                        );
                    }
                    else
                    {
                        tblAll = oBL.TK_CACTOA_CHUYENTRACH(
                            drop_cbtk.SelectedValue,
                            Drop_ld_phong.SelectedValue,
                            Session["CAP_XET_XU"] + "",
                            Session[ENUM_SESSION.SESSION_DONVIID] + "",
                            txtThuly_Tu.Text.Trim(),
                            txtThuly_Den.Text.Trim(),
                            phongBanId
                        );
                    }

                    if (tblAll != null && tblAll.Rows.Count > 0)
                    {
                        Table_Str_Totals.Text = tblAll.Rows[0]["TEXT_REPORT"] + "";
                    }
                }
                catch (Exception exAllTypes)
                {
                    lblmsg.Text = "BCPT_04 cần DB trả về 1 bảng tổng hợp (all loại án) theo thẩm phán. Hiện DB chưa hỗ trợ/ chưa deploy overload all-types. "
                        + exAllTypes.Message;
                    return;
                }

                if (string.IsNullOrWhiteSpace(Table_Str_Totals.Text))
                {
                    lblmsg.Text = "Không có dữ liệu báo cáo BCPT_04 trong khoảng ngày đã chọn.";
                    return;
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=TK_cactoa_chuyentrach.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_5()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                Literal Table_Str_Totals = new Literal();

                string selectedThamPhan = GetPostedDropDownValue(ddlThamphan);
                string selectedPhongBan = GetPostedDropDownValue(ddlPhongban);
                decimal? thamPhanId = null;
                decimal? phongBanId = null;

                if (!string.IsNullOrWhiteSpace(selectedThamPhan) && selectedThamPhan != "0")
                {
                    decimal tpId;
                    if (decimal.TryParse(selectedThamPhan, out tpId))
                    {
                        thamPhanId = tpId;
                    }
                }

                if (!string.IsNullOrWhiteSpace(selectedPhongBan) && selectedPhongBan != "0")
                {
                    decimal pbId;
                    if (decimal.TryParse(selectedPhongBan, out pbId))
                    {
                        phongBanId = pbId;
                    }
                }

                DataTable tbl = oBL.TK_TONG_HOP_FULL(
                    Session[ENUM_SESSION.SESSION_DONVIID] + "",
                    txtThuly_Tu.Text.Trim(),
                    txtThuly_Den.Text.Trim(),
                    thamPhanId,
                    phongBanId
                );
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    Table_Str_Totals.Text = tbl.Rows[0]["TEXT_REPORT"] + "";
                }

                if (string.IsNullOrWhiteSpace(Table_Str_Totals.Text))
                {
                    lblmsg.Text = "Không có dữ liệu báo cáo BCPT_05 trong khoảng ngày đã chọn.";
                    return;
                }

                HashSet<string> allowedNames = null;
                if (!string.IsNullOrEmpty(selectedThamPhan) && selectedThamPhan != "0")
                {
                    ListItem item = ddlThamphan.Items.FindByValue(selectedThamPhan);
                    string selectedName = item != null ? item.Text : (ddlThamphan.SelectedItem != null ? ddlThamphan.SelectedItem.Text : string.Empty);

                    if (!string.IsNullOrWhiteSpace(selectedName))
                    {
                        allowedNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { selectedName.Trim() };
                    }
                }
                else if (!string.IsNullOrEmpty(selectedPhongBan) && selectedPhongBan != "0")
                {
                    decimal phongBanIdValue;
                    if (decimal.TryParse(selectedPhongBan, out phongBanIdValue) && phongBanIdValue > 0)
                    {
                        allowedNames = GetThamPhanNamesByPhongBan(phongBanIdValue);
                    }
                }

                if (allowedNames != null && allowedNames.Count > 0)
                {
                    Table_Str_Totals.Text = FilterReportByJudge(Table_Str_Totals.Text, allowedNames);
                }

                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BCPT_05_TongHop_ThamPhan.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_bcpt_6()
        {
            try
            {
                STPT_BAOCAO_BL oBL = new STPT_BAOCAO_BL();
                DataTable tbl = oBL.TK_LOAIAN_THAMPHAN(Session[ENUM_SESSION.SESSION_DONVIID] + "", txtThuly_Tu.Text.Trim(), txtThuly_Den.Text.Trim(), ddlThamphan.SelectedValue);
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=TK_loaian_thamphan.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }


    }
}
using AjaxControlToolkit;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.DANHMUC;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET.THONGKE;
using BL.GSTP.QLAN;
using BL.GSTP.Quantri;
using DAL.GSTP;
using DevExpress.DataProcessing.InMemoryDataProcessor;
using DevExpress.Web;
using Module.Common;
using Module.Common.Auth;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN
{
    public partial class MaHoaBanAn2 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private BAQD_CONGBO bAQD_CONGBO = new BAQD_CONGBO();
        private List<BAQD_FILE> lstFile = new List<BAQD_FILE>();
        private RSAHelprer rSAHelprer;
        private decimal hsID = 0;
        private List<string> fileAccept = new List<string>() {
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "application/pdf"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            string hsID = Request.QueryString["hsID"];
            if (String.IsNullOrEmpty(hsID))
            {
                Response.Redirect("/Trangchu.aspx");
            }

            if (Session[ENUM_SESSION.RSA] == null)
            {
                this.rSAHelprer = new RSAHelprer();
                Session[ENUM_SESSION.RSA] = this.rSAHelprer;
            }
            else
            {
                this.rSAHelprer = Session[ENUM_SESSION.RSA] as RSAHelprer;
            }
            if (!String.IsNullOrEmpty(hsID))
            {
                try
                {
                    this.hsID = Convert.ToDecimal(this.rSAHelprer.Decryption(hsID));
                }
                catch { }
            }
            if (!String.IsNullOrEmpty(hsID))
            {
                try
                {
                    this.bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(this.hsID);
                }
                catch { }
            }
            if (this.bAQD_CONGBO == null)
            {
                Response.Redirect("/Trangchu.aspx");
            }

            if (!Page.IsPostBack)
            {
                LoadLoaiAn();
                LoadDrop_Anle();

                if (this.bAQD_CONGBO != null)
                {
                    LoadInfo(this.bAQD_CONGBO);
                }

                string filePath = Request.FilePath;

                this.LoadGrid();
                this.InitCommandName(new List<IButtonControl>() { btnLuuTepGoc, btnXemTepGoc, btnSuaTepGoc, btnXoaTepGoc, btnTaiVeTepGoc, btnMaHoaTepGoc, lblDownloadTepGoc }, ENUM_LOAI_FILE.FILE_GOC.toIntString());
                this.InitCommandName(new List<IButtonControl>() { btnLuuTepDaPhatHanh, btnXemTepDaPhatHanh, btnSuaTepDaPhatHanh, btnXoaTepDaPhatHanh, btnTaiVeTepDaPhatHanh, lblDownloadTepDaPhatHanh }, ENUM_LOAI_FILE.FILE_DONG_DAU.toIntString());
                this.InitCommandName(new List<IButtonControl>() { btnLuuTepDaMaHoa, btnXemTepDaMaHoa, btnSuaTepDaMaHoa, btnXoaTepDaMaHoa, btnTaiVeTepDaMaHoa, btnCongBoTepDaMaHoa, lblDownloadTepDaMaHoa }, ENUM_LOAI_FILE.FILE_DA_MA_HOA.toIntString());
                btnXemTepGoc.Visible =
                    btnSuaTepGoc.Visible =
                    btnXemTepDaPhatHanh.Visible =
                    btnSuaTepDaPhatHanh.Visible =
                    btnXemTepDaMaHoa.Visible =
                    btnSuaTepDaMaHoa.Visible = false;

                if (this.bAQD_CONGBO.TRANGTHAI == 2)
                {
                    this.DisableAllButton("Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa");
                }
                if (this.bAQD_CONGBO.TRANGTHAI == 3)
                {
                    this.DisableAllButton("Bản án/Quyết định đã được hủy công bố. Không cho phép sửa/xóa");
                }
                Page.Form.Enctype = "multipart/form-data";
                this.ButtonPermission();
                InitTroLyAo();
                InitFrom();
            }
        }
        private void LoadLoaiAn()
        {
            ddlCBBA_Loaian.Items.Clear();
            ddlCBBA_Loaian.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ddlCBBA_Loaian.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlCBBA_Loaian.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlCBBA_Loaian.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlCBBA_Loaian.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlCBBA_Loaian.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlCBBA_Loaian.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));
            ddlCBBA_Loaian.Items.Add(new ListItem("Biện pháp xử lý hành chính", ENUM_LOAIVUVIEC_NUMBER.BPXLHC));
        }
        private void LoadDrop_Anle()
        {
            CONGBO_BL TK_BL = new CONGBO_BL();
            DataTable tbl_anle = TK_BL.DBLINK_GET_LIST_ANLE();
            ddlCBBA_Anle.DataSource = tbl_anle;
            ddlCBBA_Anle.DataTextField = "SO_ANLE";
            ddlCBBA_Anle.DataValueField = "SO_ANLE";
            ddlCBBA_Anle.DataBind();
            ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
        }
        private void LoadDrop_QHPL()
        {
            CONGBO_BL TK_BL = new CONGBO_BL();
            int CASES_STYLES = -1;
            switch (ddlCBBA_Loaian.SelectedItem.ToString())
            {
                case "Hình sự": CASES_STYLES = 50; break;
                case "Dân sự": CASES_STYLES = 0; break;
                case "Hôn nhân gia đình": CASES_STYLES = 1; break;
                case "Kinh doanh, thương mại": CASES_STYLES = 2; break;
                case "Lao động": CASES_STYLES = 3; break;
                case "Hành chính": CASES_STYLES = 4; break;
                case "Phá sản": CASES_STYLES = 5; break;
                case "Biện pháp xử lý hành chính": CASES_STYLES = 11; break;
            }

            DataTable tbl;
            if (CASES_STYLES == 50)
            {
                tbl = TK_BL.DBLINK_GET_LIST_TC_CRIMINALS_LIST_FRONT_END();
                ddlCBBC_QHPL.DataSource = tbl;
                ddlCBBC_QHPL.DataTextField = "CRIMINAL_NAME";
                ddlCBBC_QHPL.DataValueField = "ID";
                ddlCBBC_QHPL.DataBind();
            }
            else
            {
                tbl = TK_BL.DBLINK_GET_LIST_TC_CASES_LIST_FULL(CASES_STYLES.ToString());
                ddlCBBC_QHPL.DataSource = tbl;
                ddlCBBC_QHPL.DataTextField = "CASE_NAME";
                ddlCBBC_QHPL.DataValueField = "ID";
                ddlCBBC_QHPL.DataBind();
            }
            ddlCBBC_QHPL.Items.Insert(0, new ListItem(" -- Chọn QHPL -- ", "0"));
        }

        private void LoadInfo(BAQD_CONGBO BAQD_Congbo)
        {
            txtCBBA_Mavuviec.Text = BAQD_Congbo.MAVUAN;
            ddlCBBA_Capxetxu.SelectedValue = BAQD_Congbo.CAPXETXU.ToString();
            ddlCBBA_BAQD.SelectedValue = BAQD_Congbo.ISBA.ToString();

            int CASES_STYLES = -1;
            switch (Convert.ToInt16(BAQD_Congbo.LOAIANID))
            {
                case 1: ddlCBBA_Loaian.SelectedValue = "1"; CASES_STYLES = 50; break;
                case 2: ddlCBBA_Loaian.SelectedValue = "2"; CASES_STYLES = 0; break;
                case 3: ddlCBBA_Loaian.SelectedValue = "3"; CASES_STYLES = 1; break;
                case 4: ddlCBBA_Loaian.SelectedValue = "4"; CASES_STYLES = 2; break;
                case 5: ddlCBBA_Loaian.SelectedValue = "5"; CASES_STYLES = 3; break;
                case 6: ddlCBBA_Loaian.SelectedValue = "6"; CASES_STYLES = 4; break;
                case 7: ddlCBBA_Loaian.SelectedValue = "7"; CASES_STYLES = 5; break;
                case 8: ddlCBBA_Loaian.SelectedValue = "8"; CASES_STYLES = 11; break;
            }

            LoadDrop_QHPL();

            decimal QHPL_ID = 0;

            txtCBBA_Tenvuviec_Congbo.Text = this.bAQD_CONGBO.TENVIVIEC_MAHOA;
            txtCBBA_Thongtinvuviec.Text = this.bAQD_CONGBO.THONGTINVUVIEC;


            CONGBO_BL obj_CB = new CONGBO_BL();
            DataTable tbl = obj_CB.Get_Thongtin_Banan_Quyetdinh(BAQD_Congbo);

            if (tbl != null)
            {
                if (tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    txtCBBA_SoBAQD.Text = row["SOBAQD"] != DBNull.Value ? row["SOBAQD"].ToString() : "";
                    txtCBBA_NgayBAQD.Text = row["NGAYBAQD"] != DBNull.Value ? Convert.ToDateTime(row["NGAYBAQD"]).ToString("dd/MM/yyyy") : "";
                    txtCBBA_NgayBAQD_Hieuluc.Text = Convert.ToDateTime(BAQD_Congbo.NGAYHIEULUC).ToString("dd/MM/yyyy");
                    if (row["SOANLE"] != DBNull.Value)
                    {
                        ddlCBBA_Anle.SelectedValue = row["SOANLE"].ToString();
                        ddlCBBA_Anle.Enabled = false;
                    }
                    if (row["QHPLTKID"] != DBNull.Value)
                    {
                        QHPL_ID = Convert.ToDecimal(row["QHPLTKID"]);
                        ddlCBBC_QHPL.SelectedValue = QHPL_ID.ToString();
                    }
                }
            }

            try
            {
                if (CASES_STYLES == 50)
                {
                    DM_BOLUAT_TOIDANH_QHTK obj = DataExtensions.GetAllWithClause<DM_BOLUAT_TOIDANH_QHTK>($"TOIDANH_ID = {QHPL_ID}").FirstOrDefault();
                    ddlCBBC_QHPL.SelectedValue = obj.CONGBO_CASE_ID.ToString();
                    ddlCBBC_QHPL.Enabled = false;

                }
                else
                {
                    DM_QHPL_TK obj = dt.DM_QHPL_TK.Where(x => x.ID == QHPL_ID).FirstOrDefault<DM_QHPL_TK>();
                    ddlCBBC_QHPL.SelectedValue = obj.CONGBO_CASE_ID.ToString();
                    ddlCBBC_QHPL.Enabled = false;
                }
            }
            catch
            {
                ddlCBBC_QHPL.Enabled = true;
                lblthongbaoCongbo.Text = "Có lỗi trong quá trình lưu Tội danh/QHPL. Vui lòng liên hệ với Cục CNTT để được hỗ trợ.";
            }

            reload_rdbThoihandang();
        }

        void reload_rdbThoihandang()
        {
            double songay = 0;
            if (bAQD_CONGBO.CAPXETXU == 2)
            {
                songay = 30;
            }
            else if (bAQD_CONGBO.CAPXETXU == 3)
            {
                songay = 30;
            }
            else
            {
                songay = 30;
            }

            string input = txtCBBA_NgayBAQD_Hieuluc.Text.Trim() == "" ? txtCBBA_NgayBAQD.Text.Trim() : txtCBBA_NgayBAQD_Hieuluc.Text.Trim();
            string[] dinhDang = { "d/M/yyyy", "dd/MM/yyyy", "d/MM/yyyy", "dd/M/yyyy" };

            DateTime ngayHieuLuc;
            if (DateTime.TryParseExact(input, dinhDang, CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayHieuLuc))
            {
                DateTime ngayCong = ngayHieuLuc.AddDays(songay);
                if (ngayCong > DateTime.Now)
                {
                    // Điều kiện đúng: ngày hiệu lực + 30 > ngày hiện tại
                    // Thực hiện hành động tại đây
                    rdbThoihandang.SelectedValue = "0";
                }
                else
                {
                    // Điều kiện sai
                    rdbThoihandang.SelectedValue = "1";
                }
            }
            else
            {
                // Xử lý lỗi định dạng ngày không hợp lệ
                return;
            }
        }
        private void ButtonPermission()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

            if (oPer.CAPNHAT == false)
            {

                this.SetButton(btnLuuTepGoc, false);
                this.SetButton(btnSuaTepGoc, false);

                this.SetButton(btnLuuTepDaMaHoa, false);
                this.SetButton(btnSuaTepDaMaHoa, false);

                this.SetButton(btnLuuTepDaPhatHanh, false);
                this.SetButton(btnSuaTepDaPhatHanh, false);

                this.SetButton(btnMaHoaTepGoc, false);

                this.SetButton(btnCongBoTepDaMaHoa, false);
            }

            if (oPer.XOA == false)
            {
                this.SetButton(btnXoaTepGoc, false);
                this.SetButton(btnXoaTepDaMaHoa, false);
                this.SetButton(btnXoaTepDaPhatHanh, false);
            }

        }
        private void InitCommandName(List<IButtonControl> lstBtn, string CommandName)
        {
            lstBtn.ForEach(btn =>
            {
                btn.CommandName = CommandName;
            });
        }
        private void DisableAllButton(string message)
        {
            this.UpdateThongBao(message, null);

            this.SetButton(btnLuuTepGoc, false);
            this.SetButton(btnSuaTepGoc, false);
            this.SetButton(btnXoaTepGoc, false);
            this.SetButton(btnMaHoaTepGoc, false);

            this.SetButton(btnLuuTepDaMaHoa, false);
            this.SetButton(btnSuaTepDaMaHoa, false);
            this.SetButton(btnXoaTepDaMaHoa, false);
            this.SetButton(btnCongBoTepDaMaHoa, false);

            this.SetButton(btnLuuTepDaPhatHanh, false);
            this.SetButton(btnSuaTepDaPhatHanh, false);
            this.SetButton(btnXoaTepDaPhatHanh, false);
        }

        private async void InitTroLyAo()
        {
            #region Khởi tạo hoặc set trợ lý ảo nếu chưa có

            TroLyAoInfor troLyAo;
            if (HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] == null)
            {
                troLyAo = await TroLyAoHelper.GetToken();
                HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] = troLyAo;
            }
            else
            {
                troLyAo = HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] as TroLyAoInfor;
            }
            if (troLyAo == null)
            {
            }

            #endregion Khởi tạo hoặc set trợ lý ảo nếu chưa có
        }

        private void InitFrom()
        {
        }
        public void SetButton(Button btn, bool flag)
        {
            if (flag)
            {
                btn.Enabled = true;
                btn.CssClass = "mt-2 d-w-45 btn buttoninput";
            }
            else
            {
                btn.Enabled = false;
                btn.CssClass = "mt-2 d-w-45 btn buttondisable";
            }
        }
        private void LoadGrid()
        {
            List<BAQD_FILE> lst = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID}");

            BAQD_FILE tepGoc = lst.FirstOrDefault(i => i.LOAIFILE == (int)ENUM_LOAI_FILE.FILE_GOC);
            if (tepGoc != null)
            {
                txtTenTepGoc.Text = tepGoc.TENFILE;
                txtTenTepGoc.Enabled = true;
                lblNguoiSuaTepGoc.Text = tepGoc.NGUOISUA + "  " + tepGoc.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");
                lblDownloadTepGoc.Text = tepGoc.TENFILE + tepGoc.DUOIFILE;
                lblDownloadTepGoc.Visible = true;

                this.SetButton(btnMaHoaTepGoc, true);
                this.SetButton(btnTaiVeTepGoc, true);
                this.SetButton(btnXoaTepGoc, true);
                this.SetButton(btnXemTepGoc, true);
                this.SetButton(btnSuaTepGoc, true);
            }
            else
            {
                txtTenTepGoc.Enabled = false;
                txtTenTepGoc.Text = null;
                lblNguoiSuaTepGoc.Text = null;
                lblDownloadTepGoc.Visible = false;
                this.SetButton(btnMaHoaTepGoc, false);
                this.SetButton(btnTaiVeTepGoc, false);
                this.SetButton(btnXoaTepGoc, false);
                this.SetButton(btnXemTepGoc, false);
                this.SetButton(btnSuaTepGoc, false);
                this.UpdateThongBao("Không có tệp. Hãy thêm tệp", ENUM_LOAI_FILE.FILE_GOC);
            }
            BAQD_FILE tepDaPhatHanh = lst.FirstOrDefault(i => i.LOAIFILE == (int)ENUM_LOAI_FILE.FILE_DONG_DAU);
            if (tepDaPhatHanh != null)
            {
                txtTenTepDaPhatHanh.Enabled = true;
                txtTenTepDaPhatHanh.Text = tepDaPhatHanh.TENFILE;
                lblNguoiSuaTepDaPhatHanh.Text = tepDaPhatHanh.NGUOISUA + "  " + tepDaPhatHanh.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");
                lblDownloadTepDaPhatHanh.Text = tepDaPhatHanh.TENFILE + tepDaPhatHanh.DUOIFILE;
                lblDownloadTepDaPhatHanh.Visible = true;

                this.SetButton(btnTaiVeTepDaPhatHanh, true);
                this.SetButton(btnXoaTepDaPhatHanh, true);
                this.SetButton(btnXemTepDaPhatHanh, true);
                this.SetButton(btnSuaTepDaPhatHanh, true);
            }
            else
            {
                txtTenTepDaPhatHanh.Enabled = false;
                lblDownloadTepDaPhatHanh.Visible = false;
                txtTenTepDaPhatHanh.Text = null;
                lblNguoiSuaTepDaPhatHanh.Text = null;
                this.SetButton(btnTaiVeTepDaPhatHanh, false);
                this.SetButton(btnXoaTepDaPhatHanh, false);
                this.SetButton(btnXemTepDaPhatHanh, false);
                this.SetButton(btnSuaTepDaPhatHanh, false);
                this.UpdateThongBao("Không có tệp. Hãy thêm tệp", ENUM_LOAI_FILE.FILE_DONG_DAU);
            }

            BAQD_FILE tepDaMaHoa = lst.FirstOrDefault(i => i.LOAIFILE == (int)ENUM_LOAI_FILE.FILE_DA_MA_HOA);
            if (tepDaMaHoa != null)
            {
                txtTenTepDaMaHoa.Enabled = true;
                txtTenTepDaMaHoa.Text = tepDaMaHoa.TENFILE;
                lblNguoiSuaTepDaMaHoa.Text = tepDaMaHoa.NGUOISUA + "  " + tepDaMaHoa.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");
                lblDownloadTepDaMaHoa.Text = tepDaMaHoa.TENFILE + tepDaMaHoa.DUOIFILE;
                lblDownloadTepDaMaHoa.Visible = true;

                this.SetButton(btnTaiVeTepDaMaHoa, true);
                this.SetButton(btnXoaTepDaMaHoa, true);
                this.SetButton(btnXemTepDaMaHoa, true);
                this.SetButton(btnSuaTepDaMaHoa, true);
                this.SetButton(btnCongBoTepDaMaHoa, true);
            }
            else
            {
                txtTenTepDaMaHoa.Enabled = false;
                lblDownloadTepDaMaHoa.Visible = false;
                txtTenTepDaMaHoa.Text = null;
                lblNguoiSuaTepDaMaHoa.Text = null;
                this.SetButton(btnTaiVeTepDaMaHoa, false);
                this.SetButton(btnXoaTepDaMaHoa, false);
                this.SetButton(btnXemTepDaMaHoa, false);
                this.SetButton(btnSuaTepDaMaHoa, false);
                this.SetButton(btnCongBoTepDaMaHoa, false);
                this.UpdateThongBao("Không có tệp. Hãy thêm tệp", ENUM_LOAI_FILE.FILE_DA_MA_HOA);
            }
        }

        protected void OnLoaiTepChecked(object sender, EventArgs e)
        {
            try
            {
                ASPxCheckBox checkBox = sender as ASPxCheckBox;
                if (checkBox != null)
                {
                    //checkBox.Checked = true;
                }
            }
            catch
            {
                throw new MessageException("Dữ liệu không hợp lệ");
            }
        }
        private void UpdateThongBao(string message, ENUM_LOAI_FILE? LoaiTep)
        {
            if (LoaiTep == null || LoaiTep == ENUM_LOAI_FILE.FILE_GOC)
            {
                lblThongbaoTepGoc.Text = message;
            }
            if (LoaiTep == null || LoaiTep == ENUM_LOAI_FILE.FILE_DONG_DAU)
            {
                lblThongbaoTepDaPhatHanh.Text = message;
            }
            if (LoaiTep == null || LoaiTep == ENUM_LOAI_FILE.FILE_DA_MA_HOA)
            {
                lblThongbaoTepDaMaHoa.Text = message;
            }
        }
        protected void btnSua_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;
            if (button == null)
                return;
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.CAPNHAT == false)
            {
                this.UpdateThongBao("Bạn không có quyền cập nhật dữ liệu", LoaiTep: loaiTep);
                return;
            }

            if (this.bAQD_CONGBO.TRANGTHAI == 2)
            {
                this.UpdateThongBao("Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa", loaiTep);
                return;
            }
            BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}").FirstOrDefault();

            switch (loaiTep)
            {
                case ENUM_LOAI_FILE.FILE_GOC:
                    txtTenTepGoc.Enabled = true;
                    break;
                case ENUM_LOAI_FILE.FILE_DA_MA_HOA:
                    txtTenTepDaMaHoa.Enabled = true;
                    break;
                case ENUM_LOAI_FILE.FILE_DONG_DAU:
                    txtTenTepDaPhatHanh.Enabled = true;
                    break;
            }
        }
        private bool CheckValid_Congbo()
        {
            if (String.IsNullOrEmpty(ddlCBBA_Loaian.SelectedValue))
            {
                lblthongbaoCongbo.Text = "Lỗi: Không tìm thấy Loại án";
                return false;
            }
            if (String.IsNullOrEmpty(ddlCBBA_Capxetxu.SelectedValue))
            {
                lblthongbaoCongbo.Text = "Lỗi: Không tìm thấy Cấp xét xử";
                return false;
            }
            if (String.IsNullOrEmpty(ddlCBBA_BAQD.SelectedValue))
            {
                lblthongbaoCongbo.Text = "Lỗi: Không tìm thấy Loại Bản án hay Quyết định";
                return false;
            }
            if (String.IsNullOrEmpty(txtCBBA_SoBAQD.Text))
            {
                lblthongbaoCongbo.Text = "Lỗi: Không tìm thấy Số văn bản";
                return false;
            }
            if (String.IsNullOrEmpty(txtCBBA_Tenvuviec_Congbo.Text))
            {
                lblthongbaoCongbo.Text = "Bạn chưa nhập Tên vụ việc (Lưu ý: Phải mã hóa tên đương sự)";
                return false;
            }
            if (String.IsNullOrEmpty(txtCBBA_Thongtinvuviec.Text))
            {
                lblthongbaoCongbo.Text = "Bạn chưa nhập Thông tin vụ việc";
                return false;
            }
            if (ddlCBBC_QHPL.SelectedIndex == 0)
            {
                lblthongbaoCongbo.Text = "Bạn chưa chọn Tội danh/QHPL";
                return false;
            }
            if (String.IsNullOrEmpty(txtCBBA_NgayBAQD_Hieuluc.Text))
            {
                lblthongbaoCongbo.Text = "Bạn chưa nhập Ngày hiệu lực";
                return false;
            }

            lblthongbaoCongbo.Text = "";
            return true;
        }
        protected void btnCongBo_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid_Congbo())
                {
                    return;
                }

                Button button = sender as Button;
                if (button == null)
                    return;
                var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.CAPNHAT == false)
                {
                    this.UpdateThongBao("Bạn không có quyền cập nhật dữ liệu", LoaiTep: loaiTep);
                    return;
                }

                BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)ENUM_LOAI_FILE.FILE_DA_MA_HOA}").FirstOrDefault();
                if (bAQD_FILE == null)
                {
                    this.UpdateThongBao("Không tồn tại tệp đã mã hóa", ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                    return;
                }

                // Kiểm tra xem file có phải là PDF không
                string fileName = bAQD_FILE.DUOIFILE;
                if (string.IsNullOrEmpty(fileName) || !fileName.Trim().ToLower().EndsWith(".pdf"))
                {
                    this.UpdateThongBao("Tệp đính kèm không phải là PDF. Vui lòng đính kèm lại tệp định dạng PDF trước khi công bố.", ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                    return;
                }

                this.bAQD_CONGBO.TRANGTHAI = 2;
                this.bAQD_CONGBO.NGAYSUA = DateTime.Now;
                this.bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                this.bAQD_CONGBO.TENVIVIEC_MAHOA = txtCBBA_Tenvuviec_Congbo.Text;
                this.bAQD_CONGBO.THONGTINVUVIEC = txtCBBA_Thongtinvuviec.Text;

                BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                {
                    BAQD_CONGBO_ID = this.bAQD_CONGBO.ID,
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                    HANHDONG = "CONGBO"
                };
                ls.NGAYTAO = DateTime.Now;

                /* CBBA: 1- QĐ 0- BA
                 * QLTA: 1- BA 0- QĐ
                 */
                int STATUS_JUDGMENT = 0;
                if (Convert.ToInt16(this.bAQD_CONGBO.ISBA) == 0) { STATUS_JUDGMENT = 1; }
                else if (Convert.ToInt16(this.bAQD_CONGBO.ISBA) == 1) { STATUS_JUDGMENT = 0; }

                /* ST = 0, PT = 1, GDT - 2, TT -3*/
                int LEVEL_JUDGMENT = 0;
                if (Convert.ToInt16(this.bAQD_CONGBO.CAPXETXU) == 2) { LEVEL_JUDGMENT = 0; }
                else if (Convert.ToInt16(this.bAQD_CONGBO.CAPXETXU) == 3) { LEVEL_JUDGMENT = 1; }
                else if (Convert.ToInt16(this.bAQD_CONGBO.CAPXETXU) == 4) { LEVEL_JUDGMENT = 2; }
                else if (Convert.ToInt16(this.bAQD_CONGBO.CAPXETXU) == 6) { LEVEL_JUDGMENT = 3; }

                int CASES_STYLES = -1;
                switch (ddlCBBA_Loaian.SelectedItem.ToString())
                {
                    case "Hình sự": CASES_STYLES = 50; break;
                    case "Dân sự": CASES_STYLES = 0; break;
                    case "Hôn nhân gia đình": CASES_STYLES = 1; break;
                    case "Kinh doanh, thương mại": CASES_STYLES = 2; break;
                    case "Lao động": CASES_STYLES = 3; break;
                    case "Hành chính": CASES_STYLES = 4; break;
                    case "Phá sản": CASES_STYLES = 5; break;
                    case "Biện pháp xử lý hành chính": CASES_STYLES = 11; break;
                }

                CONGBO_BL TK_BL = new CONGBO_BL();
                int COURTID = Convert.ToInt32(TK_BL.DBLINK_GET_TOAANID_CONGBO(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])));

                int PUBLICSTATUS = Convert.ToInt32(rdbThoihandang.SelectedValue);
                int CREATEUSERID = Convert.ToInt32(Session[ENUM_SESSION.SESSION_USERID]);
                string CREATEUSER = Convert.ToString(Session[ENUM_SESSION.SESSION_USERNAME]);

                Public_JudgmentInsertDto Public_JudgmentInsert;

                try
                {
                    /* Public_Judgment */
                    Public_JudgmentInsert = new Public_JudgmentInsertDto
                    {
                        NameJudgment = txtCBBA_Tenvuviec_Congbo.Text, // Tên vụ việc đã mã hóa
                        LevelJudgment = LEVEL_JUDGMENT, // Cấp xét xử
                        CourtId = COURTID, // Tòa xử
                        StatusJudgment = STATUS_JUDGMENT, // Loại BA/QĐ
                        CasesStyles = CASES_STYLES, // Loại án
                        NumberJudgment = txtCBBA_SoBAQD.Text, // Số BA/QĐ
                        DayJudgment = DateTime.ParseExact(txtCBBA_NgayBAQD.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), // Ngày BA/QĐ
                        CasesId = Convert.ToInt32(ddlCBBC_QHPL.SelectedValue), // Quan hệ pháp luật
                        SummaryContent = txtCBBA_Thongtinvuviec.Text, // Tóm tắt nội dung
                        DatePublic = DateTime.Now, // Thời gian công bố
                        Status = 1, // Trạng thái công bố (Đã công bố, chưa công bố)
                        PublicStatus = PUBLICSTATUS, // Công bố đúng, công bố chậm, công bố không chính xác
                        CreateUserId = CREATEUSERID, // Người công bố BA/QĐ
                        CreateUser = CREATEUSER, // Người tạo
                        DateActivation = txtCBBA_NgayBAQD_Hieuluc.Text == "" ? null : txtCBBA_NgayBAQD_Hieuluc.Text // Ngày hiệu lực 
                    };
                }
                catch (Exception ex)
                {
                    this.UpdateThongBao(ex.Message, ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                    return;
                }
                ;


                string jsonString = JsonConvert.SerializeObject(Public_JudgmentInsert);
                decimal id_Public_JudgmentInsert = 0;
                if (this.bAQD_CONGBO.PUBLIC_JUDGMENT_ID != null)
                {
                    CallApiCBBA.Update(jsonString).GetAwaiter().GetResult();
                    id_Public_JudgmentInsert = Convert.ToDecimal(this.bAQD_CONGBO.PUBLIC_JUDGMENT_ID);
                }
                else
                {
                    id_Public_JudgmentInsert = CallApiCBBA.Insert(jsonString).GetAwaiter().GetResult();
                    this.bAQD_CONGBO.PUBLIC_JUDGMENT_ID = id_Public_JudgmentInsert;
                }


                /* Public_file_attach */
                QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)bAQD_FILE.FILESERVER_ID);
                var _Public_file_attach = new Public_file_attach
                {
                    iD_JUDGMENT = Convert.ToInt32(id_Public_JudgmentInsert),
                    filE_ATTACH = null,
                    filE_NAME = qT_FILE.FILE_NAME + qT_FILE.FILE_TYPE,
                    datE_ATTACH = null,
                    filE_URL = qT_FILE.FILE_URL
                };
                string jsonStringa = JsonConvert.SerializeObject(_Public_file_attach);
                decimal? id_Public_file_attach = CallApiCBBA.Insert_File_attach(jsonStringa).GetAwaiter().GetResult();

                /* Public_an_le */
                var _Public_Anle = new Public_an_le
                {
                    ID_JUDGMENT = Convert.ToInt32(id_Public_JudgmentInsert),
                    NO_AN_LE = ddlCBBA_Anle.SelectedValue == "0" ? "khong" : ddlCBBA_Anle.SelectedValue
                };
                string jsonStringa_Public_Anle = JsonConvert.SerializeObject(_Public_Anle);
                decimal? id_Public_Anle = CallApiCBBA.Insert_Anle(jsonStringa_Public_Anle).GetAwaiter().GetResult();

                /* Public_slow_date */
                var _Public_Public_slow_date = new Public_slow_date
                {
                    ID_JUDGMENT = Convert.ToInt32(id_Public_JudgmentInsert),
                    NOTE_SLOW_DATE = null, /* Trường này để null*/
                    NUMBER_DATE = -1
                };
                string jsonStringa_Public_Public_slow_date = JsonConvert.SerializeObject(_Public_Public_slow_date);
                decimal? id_Public_Public_slow_date = CallApiCBBA.Insert_Slow_date(jsonStringa_Public_Public_slow_date).GetAwaiter().GetResult();


                /* Kiểm tra Công bố trước khi lưu*/
                if (id_Public_JudgmentInsert > 0 &&
                    id_Public_file_attach > 0 &&
                    id_Public_Anle > 0 &&
                    (id_Public_Public_slow_date > 0 || rdbThoihandang.SelectedValue == "0"))
                {
                    DataExtensions.Update<BAQD_CONGBO>(this.bAQD_CONGBO);
                    DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                    lblthongbaoCongbo.Text = "Công bố thành công!";
                }
                else
                {
                    lblthongbaoCongbo.Text = "Lỗi: Thông tin chưa được cập nhật lên Công bố bản án!";
                    return;
                }

                update_QLTA(this.bAQD_CONGBO);

                Page.Response.Redirect(Page.Request.Url.ToString(), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                this.UpdateThongBao(ex.Message, ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                return;
            }
        }
        private void update_QLTA(BAQD_CONGBO BAQD_Congbo)
        {
            //BAQD_Congbo.LOAIANI 1: AHS; 2: ADS; 3: AHN; 4: AKT; 5: ALD; 6: AHC; 7: APS;
            if (BAQD_Congbo.LOAIANID == 1)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        AHS_SOTHAM_BANAN STBA = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.ISANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.ISANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        AHS_PHUCTHAM_BANAN STBA = dt.AHS_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.ISANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.ISANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)}").FirstOrDefault();
                        AHS_SOTHAM_QUYETDINH_VUAN QD = DataExtensions.GetAllWithClause<AHS_SOTHAM_QUYETDINH_VUAN>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null && QD != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)}").FirstOrDefault();
                        AHS_PHUCTHAM_QUYETDINH_VUAN QD = DataExtensions.GetAllWithClause<AHS_PHUCTHAM_QUYETDINH_VUAN>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();

                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
            else if (BAQD_Congbo.LOAIANID == 2)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        ADS_SOTHAM_BANAN STBA = dt.ADS_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        ADS_PHUCTHAM_BANAN STBA = dt.ADS_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)}").FirstOrDefault();
                        ADS_SOTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<ADS_SOTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();

                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)}").FirstOrDefault();
                        ADS_PHUCTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<ADS_PHUCTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
            else if (BAQD_Congbo.LOAIANID == 3)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        AHN_SOTHAM_BANAN STBA = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.TK_APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.TK_APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        AHN_PHUCTHAM_BANAN STBA = dt.AHN_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)}").FirstOrDefault();
                        AHN_SOTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AHN_SOTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)}").FirstOrDefault();
                        AHN_PHUCTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AHN_PHUCTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
            else if (BAQD_Congbo.LOAIANID == 4)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        AKT_SOTHAM_BANAN STBA = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.TK_APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.TK_APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        AKT_PHUCTHAM_BANAN STBA = dt.AKT_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)}").FirstOrDefault();
                        AKT_SOTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AKT_SOTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)}").FirstOrDefault();
                        AKT_PHUCTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AKT_PHUCTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
            else if (BAQD_Congbo.LOAIANID == 5)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        ALD_SOTHAM_BANAN STBA = dt.ALD_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        ALD_PHUCTHAM_BANAN STBA = dt.ALD_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
                        ALD_SOTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<ALD_SOTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
                        ALD_PHUCTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<ALD_PHUCTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
            else if (BAQD_Congbo.LOAIANID == 6)
            {
                //BAQD_Congbo.ISBA 1: Bản án; 0: Quyết định
                if (BAQD_Congbo.ISBA == 1)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        AHC_SOTHAM_BANAN STBA = dt.AHC_SOTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.TK_ISANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.TK_ISANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        AHC_PHUCTHAM_BANAN STBA = dt.AHC_PHUCTHAM_BANAN.Where(x => x.ID == BAQD_Congbo.BAQDID).FirstOrDefault();
                        if (STBA != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                STBA.APDUNGANLE = 0;
                                STBA.SOANLE = "khong";
                            }
                            else
                            {
                                STBA.APDUNGANLE = 1;
                                STBA.SOANLE = ddlCBBA_Anle.Text;
                            }
                            STBA.NGAYHIEULUC = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                    }
                    dt.SaveChanges();
                }
                else if (BAQD_Congbo.ISBA == 0)
                {
                    //BAQD_Congbo.CAPXETXU 2: sơ thẩm; 3: phúc thẩm
                    if (BAQD_Congbo.CAPXETXU == 2)
                    {
                        TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)}").FirstOrDefault();
                        AHC_SOTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AHC_SOTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                    if (BAQD_Congbo.CAPXETXU == 3)
                    {
                        TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {BAQD_Congbo.BAQDID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)}").FirstOrDefault();
                        AHC_PHUCTHAM_QUYETDINH QD = DataExtensions.GetAllWithClause<AHC_PHUCTHAM_QUYETDINH>($"ID = {BAQD_Congbo.BAQDID}").FirstOrDefault();
                        if (TK != null)
                        {
                            if (ddlCBBA_Anle.SelectedValue == "0")
                            {
                                TK.APDUNGANLE = 0;
                                TK.SOANLE = "khong";
                            }
                            else
                            {
                                TK.APDUNGANLE = 1;
                                TK.SOANLE = ddlCBBA_Anle.Text;
                            }

                            TK.NGAYSUA = DateTime.Now;
                            TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            DataExtensions.Update(TK);

                            QD.HIEULUCTU = (String.IsNullOrEmpty(txtCBBA_NgayBAQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCBBA_NgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataExtensions.Update(QD);
                        }
                    }
                }
            }
        }

        protected void btnMaHoa_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;
            if (button == null)
                return;
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.CAPNHAT == false)
            {
                this.UpdateThongBao("Bạn không có quyền cập nhật dữ liệu", LoaiTep: loaiTep);
                return;
            }
            if (loaiTep != ENUM_LOAI_FILE.FILE_GOC)
            {
                this.UpdateThongBao("Chỉ mã hóa đối với tệp gốc", loaiTep);
                return;
            }
            if (this.bAQD_CONGBO.TRANGTHAI == 2)
            {
                this.UpdateThongBao("Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa", loaiTep);
                return;
            }
            BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}").FirstOrDefault();
            //BAQD_FILE bAQD_FILE = DataExtensions.FindById<BAQD_FILE>(APID);
            if (bAQD_FILE == null)
            {
                this.UpdateThongBao("Không thể lấy tệp", loaiTep);
                return;
            }
            if (HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] == null)
            {
                this.UpdateThongBao("Khởi tạo thất bại hay tải lại hoặc đăng nhập lại", loaiTep);
                return;
            }
            if (HttpContext.Current.Session[ENUM_SESSION.SESSION_USERNAME] == null)
            {
                this.UpdateThongBao("Hết phiên truy cập. Hãy đăng nhập lại", loaiTep);
                return;
            }
            QT_FILE qT_FILEMaHoa = new QT_FILE()
            {
                DATE_CREATED = bAQD_FILE.NGAYTAO,
                FILE_NAME = bAQD_FILE.TENFILENATIVE,
                ID = bAQD_FILE.FILESERVER_ID ?? 0,
                FILE_TYPE = bAQD_FILE.DUOIFILE.ToString()
            };
            QT_FILE_BL fileMaHoa = new QT_FILE_BL();
            //byte[] fileMaHoaByte = fileMaHoa.GetNoiDungFile_Minio(qT_FILEMaHoa, Convert.ToInt32(bAQD_CONGBO.LOAIANID));

            //var cacheKeyMaHoa = Guid.NewGuid().ToString("N");
            //Context.Cache.Insert(key: cacheKeyMaHoa, value: fileMaHoaByte, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
            //ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnClickMaHoaBanAn", string.Format("OnClickMaHoaBanAn('{0}','{1}');", Cls_Comon.GetRootURL() + 
            //                                                                                                                                "/DownloadFile.aspx?cacheKey=" + cacheKeyMaHoa + "&FileName=" + "" +
            //                                                                                                                                "&Extension=" + bAQD_FILE.DUOIFILE
            //                                                                                                                                , JsonConvert.SerializeObject(HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] as TroLyAoInfor)), true);
            byte[] fileMaHoaByte = fileMaHoa.GetNoiDungFile_Minio(qT_FILEMaHoa, Convert.ToInt32(bAQD_CONGBO.LOAIANID));

            var cacheKeyMaHoa = Guid.NewGuid().ToString("N");

            Context.Cache.Insert(
                key: cacheKeyMaHoa,
                value: fileMaHoaByte,
                dependencies: null,
                absoluteExpiration: DateTime.Now.AddSeconds(30),
                slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration
            );

            // Tạo URL đúng chuẩn
            string fileName = "BanAnMaHoa"; // đặt tên file cho đẹp
            string extension = bAQD_FILE.DUOIFILE;

            string url = Cls_Comon.GetRootURL() +
                         "/DownloadFile.aspx?cacheKey=" + cacheKeyMaHoa +
                         "&FileName=" + HttpUtility.UrlEncode(fileName) +
                         "&Extension=" + HttpUtility.UrlEncode(extension);

            // Gọi JS đúng cách
            //ScriptManager.RegisterStartupScript(
            //    this.Page,
            //    GetType(),
            //    "OnClickMaHoaBanAn",
            //    $"OnClickMaHoaBanAn('{url}');",
            //    true
            //);


            var troLyJson = JsonConvert.SerializeObject(HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] as TroLyAoInfor); // object của bạn
            url = url.Replace("http://", "https://"); // đảm bảo URL là https)
            ScriptManager.RegisterStartupScript(
                this.Page,
                GetType(),
                "OnClickMaHoaBanAn",
                $"OnClickMaHoaBanAn('{url}', '{HttpUtility.JavaScriptStringEncode(troLyJson)}');",
                true
            );

        }
        protected void btnXoa_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;
            if (button == null)
                return;
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.XOA == false)
            {
                this.UpdateThongBao("Bạn không có quyền xóa dữ liệu", LoaiTep: loaiTep);
                return;
            }
            if (this.bAQD_CONGBO.TRANGTHAI == 2)
            {
                this.UpdateThongBao("Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa", loaiTep);
                return;
            }
            BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}").FirstOrDefault();
            if (bAQD_FILE == null)
            {
                this.UpdateThongBao("Không thể lấy file", loaiTep);
                return;
            }
            if (bAQD_FILE != null)
            {
                #region nếu File của bản án đã có thì cần xóa file đó đi

                QT_FILE qtFileDelete = new QT_FILE()
                {
                    DATE_CREATED = bAQD_FILE.NGAYSUA ?? bAQD_FILE.NGAYTAO,
                    FILE_NAME = bAQD_FILE.TENFILENATIVE,
                    ID = bAQD_FILE.FILESERVER_ID ?? 0,
                    FILE_TYPE = bAQD_FILE.DUOIFILE.ToString()
                };
                #endregion nếu File của bản án đã có thì cần xóa file đó đi

                bool result = DataExtensions.Delete(bAQD_FILE);
                if (result == true)
                {
                    BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                    {
                        BAQD_CONGBO_ID = this.bAQD_CONGBO.ID,
                        NGUOITAO = HttpContext.Current.Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                        FILESERVER_ID_OLD = bAQD_FILE.FILESERVER_ID,
                        HANHDONG = "DELETE_" + Enum.Parse(typeof(ENUM_LOAI_FILE), bAQD_FILE.LOAIFILE.ToString()),
                    };
                    ls.NGAYTAO = DateTime.Now;
                    DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                    this.UpdateThongBao("Xóa tệp thành công", loaiTep);
                    #region Nếu đang bật sửa thông tin file đó thì làm mới from
                    try
                    {
                        if (bAQD_FILE.LOAIFILE == (int)loaiTep)
                        {
                            this.btnLammoi_Click(null, null);
                        }
                    }
                    catch
                    {

                    }
                    #endregion Nếu đang bật sửa thông tin file đó thì làm mới from
                    this.LoadGrid();
                }
            }
            else
            {
                this.UpdateThongBao("Không tìm thấy tệp", loaiTep);
                this.LoadGrid();
            }
        }

        protected void btnTaiVe_Click(object sender, EventArgs e)
        {
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), ((IButtonControl)sender).CommandName.ToString());
            BAQD_FILE bAQD_FILE = DataExtensions
                .GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}")
                .FirstOrDefault();

            if (bAQD_FILE == null)
            {
                this.UpdateThongBao("Không tìm thấy file để tải", loaiTep);
                return;
            }

            QT_FILE qT_FILE = new QT_FILE()
            {
                DATE_CREATED = bAQD_FILE.NGAYTAO,
                FILE_NAME = bAQD_FILE.TENFILENATIVE,
                ID = bAQD_FILE.FILESERVER_ID ?? 0,
                FILE_TYPE = bAQD_FILE.DUOIFILE.ToString()
            };

            QT_FILE_BL fileH = new QT_FILE_BL();
            byte[] fileBytes = fileH.GetNoiDungFile_Minio(qT_FILE, Convert.ToInt32(bAQD_CONGBO.LOAIANID));

            if (fileBytes == null || fileBytes.Length == 0)
            {
                this.UpdateThongBao("Không thể tải nội dung file từ MinIO.", loaiTep);
                return;
            }

            string fileName = (bAQD_FILE.TENFILE ?? bAQD_FILE.TENFILENATIVE) + bAQD_FILE.DUOIFILE;

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(fileName));
            Response.OutputStream.Write(fileBytes, 0, fileBytes.Length);
            Response.Flush();
            Response.End();
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            //CommandEventArgs
            Button button = sender as Button;
            if (button == null)
                return;
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.CAPNHAT == false)
            {
                this.UpdateThongBao("Bạn không có quyền cập nhật dữ liệu", LoaiTep: loaiTep);
                return;
            }
            try
            {
                if (this.bAQD_CONGBO.TRANGTHAI == 2)
                {
                    this.UpdateThongBao("Bản án đã công bố. Không được thao tác", LoaiTep: loaiTep);
                    return;
                }
                AsyncFileUpload file = null;
                TextBox txtTen = null;
                if ((int)loaiTep == (int)ENUM_LOAI_FILE.FILE_GOC)
                {
                    file = AsyncFileUpLoadTepGoc;
                    txtTen = txtTenTepGoc;
                }
                if ((int)loaiTep == (int)ENUM_LOAI_FILE.FILE_DA_MA_HOA)
                {
                    file = AsyncFileUpLoadTepDaMaHoa;
                    txtTen = txtTenTepDaMaHoa;
                }
                if ((int)loaiTep == (int)ENUM_LOAI_FILE.FILE_DONG_DAU)
                {
                    file = AsyncFileUpLoadTepDaPhatHanh;
                    txtTen = txtTenTepDaPhatHanh;
                }
                string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                {
                    BAQD_CONGBO_ID = this.bAQD_CONGBO.ID,
                    NGUOITAO = userName
                };
                if (Page.IsValid)
                {
                    #region Nếu đang thêm tệp mới thì bắt buộc phải có file

                    if (txtTen.Enabled == false && file.HasFile == false)
                    {
                        this.UpdateThongBao("Bạn chưa chọn tệp tải lên", LoaiTep: loaiTep);
                        return;
                    }

                    #endregion Nếu đang thêm tệp mới thì bắt buộc phải có file

                    BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}").FirstOrDefault();

                    #region Nếu không có file trong hệ thống mà lại mở tính năng sửa thì làm mới form và báo lỗi
                    if (txtTen.Enabled == true && bAQD_FILE == null)
                    {
                        this.UpdateThongBao("Thông tin loại tệp bạn đang sửa không tồn tại", LoaiTep: loaiTep);
                        this.btnLammoi_Click(null, null);
                        return;
                    }
                    #endregion Nếu không có file trong hệ thống mà lại mở tính năng sửa thì làm mới form và báo lỗi

                    bool isCreate = bAQD_FILE == null;

                    QT_FILE qtFile = null;
                    if (file.HasFile == true)
                    {
                        if (!this.fileAccept.Any(i => i.Equals(file.ContentType)))
                        {
                            this.UpdateThongBao("Tệp bạn chọn không nằm trong danh sách được phép tải lên", LoaiTep: loaiTep);
                            return;
                        }
                        HttpPostedFile postFile = file.PostedFile;
                        qtFile = this.fileHelper.InsertFile_Minio_Congbo(postFile, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                    }
                    if (bAQD_FILE != null && file.HasFile == true)
                    {
                        //bAQD_FILE = new BAQD_FILE();

                        #region nếu File của bản án đã có thì cần xóa file đó đi

                        QT_FILE qtFileDelete = new QT_FILE()
                        {
                            DATE_CREATED = bAQD_FILE.NGAYSUA ?? bAQD_FILE.NGAYTAO,
                            FILE_NAME = bAQD_FILE.TENFILENATIVE,
                            ID = bAQD_FILE.FILESERVER_ID ?? 0,
                            FILE_TYPE = bAQD_FILE.DUOIFILE.ToString()
                        };
                        ls.FILESERVER_ID_OLD = bAQD_FILE.FILESERVER_ID;

                        #endregion nếu File của bản án đã có thì cần xóa file đó đi
                    }
                    else if (bAQD_FILE == null)
                    {
                        bAQD_FILE = new BAQD_FILE();
                        bAQD_FILE.LOAIFILE = (int)loaiTep;
                        bAQD_FILE.KIEUFILE = 0;
                        bAQD_FILE.NGUOITAO = userName;
                        bAQD_FILE.NGAYTAO = qtFile.DATE_CREATED;
                        bAQD_FILE.BAQD_CONGBO_ID = this.bAQD_CONGBO.ID;
                    }

                    if (qtFile != null)
                    {
                        bAQD_FILE.TENFILE = qtFile.FILE_NAME;
                        if ((int)loaiTep == (int)ENUM_LOAI_FILE.FILE_DA_MA_HOA)
                        {
                            BAQD_FILE fileGoc = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)ENUM_LOAI_FILE.FILE_GOC}").FirstOrDefault();
                            if (fileGoc != null)
                            {
                                bAQD_FILE.TENFILE = fileGoc.TENFILE + " da_ma_hoa";
                            }
                        }
                        bAQD_FILE.TENFILENATIVE = qtFile.FILE_NAME;
                        bAQD_FILE.DUOIFILE = qtFile.FILE_TYPE;
                        bAQD_FILE.KICHTHUOC = qtFile.FILE_SIZE;
                        bAQD_FILE.FILESERVER_ID = qtFile.ID;
                        bAQD_FILE.NGUOISUA = userName;
                        bAQD_FILE.NGAYSUA = qtFile.DATE_CREATED;
                    }
                    else
                    {
                        bAQD_FILE.NGUOISUA = userName;
                        bAQD_FILE.NGAYSUA = DateTime.Now;
                    }

                    #region nếu pnTenTep có hiển thị thì là đang sửa tệp

                    if (txtTen.Enabled == true)
                    {
                        if (!String.IsNullOrEmpty(txtTen.Text))
                        {
                            bAQD_FILE.TENFILE = txtTen.Text;
                        }
                    }

                    #endregion nếu pnTenTep có hiển thị thì là đang sửa tệp

                    bool isUpdateDatabase = false;
                    if (isCreate)
                    {
                        decimal result = DataExtensions.Insert<BAQD_FILE>(bAQD_FILE);
                        if (result > 0)
                            isUpdateDatabase = true;
                        if (isUpdateDatabase)
                        {
                            this.UpdateThongBao("Thêm tệp thành công!", LoaiTep: loaiTep);
                            this.LoadGrid();
                            ls.HANHDONG = "ADD_" + loaiTep;
                            ls.FILESERVER_ID_NEW = bAQD_FILE.FILESERVER_ID;
                        }

                    }
                    else
                    {
                        isUpdateDatabase = DataExtensions.Update<BAQD_FILE>(bAQD_FILE);
                        if (isUpdateDatabase)
                        {
                            this.UpdateThongBao("Cập nhật thành công!", LoaiTep: loaiTep);
                            this.LoadGrid();
                            ls.FILESERVER_ID_NEW = bAQD_FILE.FILESERVER_ID;
                            ls.HANHDONG = "UPDATE_" + loaiTep;
                        }
                    }
                    if (!isUpdateDatabase)
                    {
                        this.UpdateThongBao("Lưu tệp không thành công. Hãy thử lại!", LoaiTep: loaiTep);
                    }
                    else
                    {
                        ls.NGAYTAO = DateTime.Now;
                        DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                        this.LoadGrid();
                        this.btnLammoi_Click(this, new EventArgs());
                    }
                }
                return;
            }
            catch
            {
                this.UpdateThongBao("Không thể tải tệp lên hệ thống", LoaiTep: loaiTep);
                return;
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
        }
    }
}
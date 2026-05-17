using AjaxControlToolkit;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using DevExpress.Web;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN
{
    public partial class MaHoaBanAn1 : System.Web.UI.Page
    {
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private BAQD_CONGBO bAQD_CONGBO = new BAQD_CONGBO();
        private List<BAQD_FILE> lstFile = new List<BAQD_FILE>();
        private RSAHelprer rSAHelprer;
        private decimal hsID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            //lblThongbao.Text = "";
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
                string filePath = Request.FilePath;
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //Cls_Comon.SetButton(btnLuu, oPer.CAPNHAT);
                this.LoadGrid();
                this.InitCommandName(new List<Button>() { btnLuuTepGoc, btnXemTepGoc, btnSuaTepGoc, btnXoaTepGoc, btnTaiVeTepGoc, btnMaHoaTepGoc }, ENUM_LOAI_FILE.FILE_GOC.toIntString());
                this.InitCommandName(new List<Button>() { btnLuuTepDaPhatHanh, btnXemTepDaPhatHanh, btnSuaTepDaPhatHanh, btnXoaTepDaPhatHanh, btnTaiVeTepDaPhatHanh }, ENUM_LOAI_FILE.FILE_DONG_DAU.toIntString());
                this.InitCommandName(new List<Button>() { btnLuuTepDaMaHoa, btnXemTepDaMaHoa, btnSuaTepDaMaHoa, btnXoaTepDaMaHoa, btnTaiVeTepDaMaHoa, btnCongBoTepDaMaHoa }, ENUM_LOAI_FILE.FILE_DA_MA_HOA.toIntString());
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
        private void InitCommandName(List<Button> lstBtn, string CommandName)
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
                btn.CssClass = "col m-0 p-0 mr-1 mt-1 buttoninput";
            }
            else
            {
                btn.Enabled = false;
                btn.CssClass = "col m-0 p-0 mr-1 mt-1 buttondisable";
            }
        }
        private void LoadGrid()
        {
            List<BAQD_FILE> lst = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID}");
            BAQD_FILE tepGoc = lst.FirstOrDefault(i => i.LOAIFILE == (int)ENUM_LOAI_FILE.FILE_GOC);
            if (tepGoc != null)
            {
                txtTenTepGoc.Text = tepGoc.TENFILE;
                lblNguoiTaoTepGoc.Text = tepGoc.NGUOITAO;
                lblNguoiSuaTepGoc.Text = tepGoc.NGUOISUA;
                lblNgayTaoTepGoc.Text = tepGoc.NGAYTAO?.ToVNDate().Replace("-", "/");
                lblNgaySuaTepGoc.Text = tepGoc.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");

                pnThongTinTepGoc.Visible = true;
                this.SetButton(btnMaHoaTepGoc, true);
                this.SetButton(btnTaiVeTepGoc, true);
                this.SetButton(btnXoaTepGoc, true);
                this.SetButton(btnXemTepGoc, true);
                this.SetButton(btnSuaTepGoc, true);
            }
            else
            {
                pnThongTinTepGoc.Visible = false;
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
                txtTenTepDaPhatHanh.Text = tepDaPhatHanh.TENFILE;
                lblNguoiTaoTepDaPhatHanh.Text = tepDaPhatHanh.NGUOITAO;
                lblNguoiSuaTepDaPhatHanh.Text = tepDaPhatHanh.NGUOISUA;
                lblNgayTaoTepDaPhatHanh.Text = tepDaPhatHanh.NGAYTAO?.ToVNDate().Replace("-", "/");
                lblNgaySuaTepDaPhatHanh.Text = tepDaPhatHanh.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");
                pnThongTinTepDaPhatHanh.Visible = true;

                this.SetButton(btnTaiVeTepDaPhatHanh, true);
                this.SetButton(btnXoaTepDaPhatHanh, true);
                this.SetButton(btnXemTepDaPhatHanh, true);
                this.SetButton(btnSuaTepDaPhatHanh, true);
            }
            else
            {
                pnThongTinTepDaPhatHanh.Visible = false;

                this.SetButton(btnTaiVeTepDaPhatHanh, false);
                this.SetButton(btnXoaTepDaPhatHanh, false);
                this.SetButton(btnXemTepDaPhatHanh, false);
                this.SetButton(btnSuaTepDaPhatHanh, false);
                this.UpdateThongBao("Không có tệp. Hãy thêm tệp", ENUM_LOAI_FILE.FILE_DONG_DAU);
            }

            BAQD_FILE tepDaMaHoa = lst.FirstOrDefault(i => i.LOAIFILE == (int)ENUM_LOAI_FILE.FILE_DA_MA_HOA);
            if (tepDaMaHoa != null)
            {
                txtTenTepDaMaHoa.Text = tepDaMaHoa.TENFILE;
                lblNguoiTaoTepDaMaHoa.Text = tepDaMaHoa.NGUOITAO;
                lblNguoiSuaTepDaMaHoa.Text = tepDaMaHoa.NGUOISUA;
                lblNgayTaoTepDaMaHoa.Text = tepDaMaHoa.NGAYTAO?.ToVNDate().Replace("-", "/");
                lblNgaySuaTepDaMaHoa.Text = tepDaMaHoa.NGAYSUA?.ToString("dd/MM/yyyy HH:mm:ss").Replace("-", "/");
                pnThongTinTepDaMaHoa.Visible = true;

                this.SetButton(btnTaiVeTepDaMaHoa, true);
                this.SetButton(btnXoaTepDaMaHoa, true);
                this.SetButton(btnXemTepDaMaHoa, true);
                this.SetButton(btnSuaTepDaMaHoa, true);
                this.SetButton(btnCongBoTepDaMaHoa, true);
            }
            else
            {
                pnThongTinTepDaMaHoa.Visible = false;

                this.SetButton(btnTaiVeTepDaMaHoa, false);
                this.SetButton(btnXoaTepDaMaHoa, false);
                this.SetButton(btnXemTepDaMaHoa, false);
                this.SetButton(btnSuaTepDaMaHoa, false);
                this.SetButton(btnCongBoTepDaMaHoa, false);
                this.UpdateThongBao("Không có tệp. Hãy thêm tệp", ENUM_LOAI_FILE.FILE_DA_MA_HOA);
            }
            txtTenTepGoc.Enabled = false;
            txtTenTepDaPhatHanh.Enabled = false;
            txtTenTepDaMaHoa.Enabled = false;
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            //string strFileName = AsyncFileUpLoad.FileName;
            //string path = Server.MapPath("~/TempUpload/") + strFileName;
            //AsyncFileUpLoad.SaveAs(path);

            //path = path.Replace("\\", "/");
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
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
        protected void btnCongBo_Click(object sender, EventArgs e)
        {
            try
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

                BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)ENUM_LOAI_FILE.FILE_DA_MA_HOA}").FirstOrDefault();
                if (bAQD_FILE == null)
                {
                    this.UpdateThongBao("Không tồn tại tệp đã mã hóa", ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                    return;
                }
                this.bAQD_CONGBO.TRANGTHAI = 2;
                this.bAQD_CONGBO.NGAYSUA = DateTime.Now;
                this.bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                DataExtensions.Update<BAQD_CONGBO>(this.bAQD_CONGBO);
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Công bố bản án thành công! ");
                Page.Response.Redirect(Page.Request.Url.ToString(), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                this.UpdateThongBao(ex.Message, ENUM_LOAI_FILE.FILE_DA_MA_HOA);
                return;
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
            byte[] fileMaHoaByte = fileMaHoa.GetNoiDungFile(qT_FILEMaHoa, Convert.ToInt32(bAQD_CONGBO.LOAIANID));
            var cacheKeyMaHoa = Guid.NewGuid().ToString("N");
            Context.Cache.Insert(key: cacheKeyMaHoa, value: fileMaHoaByte, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnClickMaHoaBanAn", string.Format("OnClickMaHoaBanAn('{0}','{1}');", Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKeyMaHoa + "&FileName=" + "" + "&Extension=" + bAQD_FILE.DUOIFILE, JsonConvert.SerializeObject(HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] as TroLyAoInfor)), true);
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
            //BAQD_FILE bAQD_FILE = DataExtensions.FindById<BAQD_FILE>(APID);
            if (bAQD_FILE == null)
            {
                this.UpdateThongBao("Không thể lấy file", loaiTep);
                return;
            }
            if (bAQD_FILE != null)
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
                bool isDelete = this.fileHelper.DeleteFile(qtFileDelete, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                if (isDelete == false)
                {
                    //trong quá trình test có thể file tồn tại ở project khác
                    //sẽ chỉ ghi đè file và không hander error
                }

                #endregion nếu File của bản án đã có thì cần xóa file đó đi

                bool result = DataExtensions.Delete(bAQD_FILE);
                if (result == true)
                {
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
            Button button = sender as Button;
            if (button == null)
                return;
            var loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), button.CommandName.ToString());
            BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)loaiTep}").FirstOrDefault();
            //BAQD_FILE bAQD_FILE = DataExtensions.FindById<BAQD_FILE>(APID);
            if (bAQD_FILE == null)
            {
                this.UpdateThongBao("Không thể lấy file", loaiTep);
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
            byte[] file = fileH.GetNoiDungFile(qT_FILE, Convert.ToInt32(bAQD_CONGBO.LOAIANID));
            var cacheKey = Guid.NewGuid().ToString("N");
            string fileName = bAQD_FILE.TENFILE ?? bAQD_FILE.TENFILENATIVE;
            Context.Cache.Insert(key: cacheKey, value: file, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "DownloadFile", string.Format("DownloadFile('{0}','{1}');", Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileName + "&Extension=" + bAQD_FILE.DUOIFILE, fileName + bAQD_FILE.DUOIFILE), true);
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
                        HttpPostedFile postFile = file.PostedFile;
                        qtFile = this.fileHelper.InsertFile(postFile, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
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
                        bool isDelete = this.fileHelper.DeleteFile(qtFileDelete, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                        if (isDelete == false)
                        {
                            //trong quá trình test có thể file tồn tại ở project khác
                            //sẽ chỉ ghi đè file và không hander error
                        }

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
                            this.UpdateThongBao("Cập nhật thành công!", LoaiTep: loaiTep);
                            this.LoadGrid();
                        }

                    }
                    else
                    {
                        isUpdateDatabase = DataExtensions.Update<BAQD_FILE>(bAQD_FILE);
                        if (isUpdateDatabase)
                        {
                            this.UpdateThongBao("Lưu thành công!", LoaiTep: loaiTep);
                            this.LoadGrid();
                        }
                    }
                    if (!isUpdateDatabase)
                    {
                        this.UpdateThongBao("Lưu tệp không thành công. Hãy thử lại!", LoaiTep: loaiTep);
                    }
                    else
                    {
                        this.LoadGrid();
                        this.btnLammoi_Click(this, new EventArgs());
                    }
                }
                return;
            }
            catch (Exception ex)
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
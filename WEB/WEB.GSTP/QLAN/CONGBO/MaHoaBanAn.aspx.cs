using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.Quantri;
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
    public partial class MaHoaBanAn : System.Web.UI.Page
    {
        private QT_FILE_BL fileHelper = new QT_FILE_BL();
        private BAQD_CONGBO bAQD_CONGBO = new BAQD_CONGBO();
        private List<BAQD_FILE> lstFile = new List<BAQD_FILE>();
        private RSAHelprer rSAHelprer;
        private decimal hsID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            lblThongbao.Text = "";
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
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(btnLuu, oPer.CAPNHAT);
                if (this.bAQD_CONGBO.TRANGTHAI == 2)
                {
                    this.DisableAllButton("Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa");
                }
                if (this.bAQD_CONGBO.TRANGTHAI == 3)
                {
                    this.DisableAllButton("Bản án/Quyết định đã được hủy công bố. Không cho phép sửa/xóa");
                }
                Page.Form.Enctype = "multipart/form-data";
                InitTroLyAo();
                InitFrom();
                this.LoadGrid();
            }
        }

        private void DisableAllButton(string message)
        {
            AsyncFileUpLoad.Enabled = false;
            Cls_Comon.SetButton(btnLuu, false);
            Cls_Comon.SetButton(btnCongBo, false);
            Cls_Comon.SetButton(btnLammoi, false);
            rdbLoaiTep.Enabled = false;
            lblThongbao.Text = message;
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
                lblThongbao.Text = "Không thể khởi tạo mã hóa hãy thử lại";
            }

            #endregion Khởi tạo hoặc set trợ lý ảo nếu chưa có
        }

        private void InitFrom()
        {
            rdbLoaiTep.Items.Add(new ListItem("Tệp gốc", ((int)ENUM_LOAI_FILE.FILE_GOC).ToString()));
            rdbLoaiTep.Items.Add(new ListItem("Tệp đã mã hóa", ((int)ENUM_LOAI_FILE.FILE_DA_MA_HOA).ToString()));
            rdbLoaiTep.Items.Add(new ListItem("Tệp đã đóng dấu", ((int)ENUM_LOAI_FILE.FILE_DONG_DAU).ToString()));
            rdbLoaiTep.SelectedIndex = 0;
        }

        private void LoadGrid()
        {
            CONGBO_BL obj = new CONGBO_BL();
            DataTable dt = obj.Get_File_Where_BAQD_CONGBO_ID(BAQD_CONGBO_ID: this.bAQD_CONGBO.ID);
            bool isMaHoaFile = false;
            foreach (var item in dt.AsEnumerable())
            {
                if ((int)ENUM_LOAI_FILE.FILE_DA_MA_HOA == Convert.ToInt16(item["LOAIFILE"]) && this.bAQD_CONGBO.TRANGTHAI != 2)
                {
                    isMaHoaFile = true;
                    break;
                }
            }
            Cls_Comon.SetButton(btnCongBo, isMaHoaFile);
            dgList.DataSource = dt;
            dgList.DataBind();
        }

        protected void dgList_ItemDataBound(object source, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                ENUM_LOAI_FILE loaiTep = (ENUM_LOAI_FILE)Enum.Parse(typeof(ENUM_LOAI_FILE), row["LOAIFILE"].ToString());

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lblXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                LinkButton lblMaHoa = (LinkButton)e.Item.FindControl("lblMaHoa");

                #region Bản án Quyết định đã được công bố thì ẩn nút xóa sửa mã hóa

                try
                {
                    if (this.bAQD_CONGBO.TRANGTHAI == 2)
                    {
                        lbtXoa.Visible = false;
                        lblSua.Visible = false;
                        lblMaHoa.Visible = false;
                        return;
                    }
                }
                catch { }

                #endregion Bản án Quyết định đã được công bố thì ẩn nút xóa sửa mã hóa

                #region nếu loại file là file gốc thì mới có mã hóa

                if (loaiTep != ENUM_LOAI_FILE.FILE_GOC)
                {
                    lblMaHoa.Visible = false;
                }

                #endregion nếu loại file là file gốc thì mới có mã hóa
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal APID = Convert.ToDecimal(e.CommandArgument.ToString());
                BAQD_FILE bAQD_FILE = DataExtensions.FindById<BAQD_FILE>(APID);
                switch (e.CommandName)
                {
                    case "Download":
                        if (bAQD_FILE == null)
                        {
                            lblThongbao.Text = "Không thể lấy file";
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
                        break;

                    case "Sua":
                        if (bAQD_FILE == null)
                        {
                            lblThongbao.Text = "Không thể lấy tệp";
                            return;
                        }
                        if (this.bAQD_CONGBO.TRANGTHAI == 2)
                        {
                            lblThongbao.Text = "Bản án đã công bố. Không được xóa tệp";
                            return;
                        }
                        txtTepID.Text = bAQD_FILE.ID.ToString();
                        pnTenTep.Visible = true;
                        rdbLoaiTep.SelectedValue = bAQD_FILE.LOAIFILE.ToString();
                        rdbLoaiTep.Enabled = false;
                        txtTenTep.Text = bAQD_FILE.TENFILE.ToString();
                        break;

                    case "MaHoa":
                        if (bAQD_FILE == null)
                        {
                            lblThongbao.Text = "Không thể lấy tệp";
                            return;
                        }
                        if (this.bAQD_CONGBO.TRANGTHAI == 2)
                        {
                            lblThongbao.Text = "Bản án đã công bố. Không được xóa tệp";
                            return;
                        }
                        if (HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] == null)
                        {
                            lblThongbao.Text = "Khởi tạo thất bại hay tải lại hoặc đăng nhập lại";
                            return;
                        }
                        if (HttpContext.Current.Session[ENUM_SESSION.SESSION_USERNAME] == null)
                        {
                            lblThongbao.Text = "Hết phiên truy cập. Hãy đăng nhập lại";
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
                        break;

                    case "Xoa":
                        if (this.bAQD_CONGBO.TRANGTHAI == 2)
                        {
                            lblThongbao.Text = "Bản án đã công bố. Không được xóa tệp";
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
                            //bool isDelete = this.fileHelper.DeleteFile(qtFileDelete, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                            //if (isDelete == false)
                            //{
                            //    //trong quá trình test có thể file tồn tại ở project khác
                            //    //sẽ chỉ ghi đè file và không hander error
                            //}

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
                                lblThongbao.Text = "Xóa tệp thành công";
                                #region Nếu đang bật sửa thông tin file đó thì làm mới from
                                try
                                {
                                    var loaiTep = Enum.Parse(typeof(ENUM_LOAI_FILE), rdbLoaiTep.SelectedValue);
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
                            lblThongbao.Text = "Không tìm thấy tệp";
                            this.LoadGrid();
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                lblThongbao.Text = ex.Message;
            }
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                //string strFileName = AsyncFileUpLoad.FileName;
                //string path = Server.MapPath("~/TempUpload/") + strFileName;
                //AsyncFileUpLoad.SaveAs(path);

                //path = path.Replace("\\", "/");
                //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
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

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {

                if (this.bAQD_CONGBO.TRANGTHAI == 2)
                {
                    lblThongbao.Text = "Bản án đã công bố. Không được thao tác";
                    return;
                }
                var loaiTep = Enum.Parse(typeof(ENUM_LOAI_FILE), rdbLoaiTep.SelectedValue);
                string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                {
                    BAQD_CONGBO_ID = this.bAQD_CONGBO.ID,
                    NGUOITAO = userName
                };
                if (Page.IsValid)
                {
                    #region Nếu đang thêm tệp mới thì bắt buộc phải có file

                    if (pnTenTep.Visible == false && AsyncFileUpLoad.HasFile == false)
                    {
                        lblThongbao.Text = "Bạn chưa chọn tệp tải lên";
                        return;
                    }

                    #endregion Nếu đang thêm tệp mới thì bắt buộc phải có file

                    BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={Convert.ToDecimal(rdbLoaiTep.SelectedValue)}").FirstOrDefault();

                    #region Nếu không có file trong hệ thống mà lại mở tính năng sửa thì làm mới form và báo lỗi
                    if (pnTenTep.Visible == true && bAQD_FILE == null)
                    {
                        lblThongbao.Text = "Thông tin loại tệp bạn đang sửa không tồn tại";
                        this.btnLammoi_Click(null, null);
                        return;
                    }
                    #endregion Nếu không có file trong hệ thống mà lại mở tính năng sửa thì làm mới form và báo lỗi

                    bool isCreate = bAQD_FILE == null;

                    QT_FILE qtFile = null;
                    if (AsyncFileUpLoad.HasFile == true)
                    {
                        HttpPostedFile postFile = AsyncFileUpLoad.PostedFile;
                        qtFile = this.fileHelper.InsertFile(postFile, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                    }
                    if (bAQD_FILE != null && AsyncFileUpLoad.HasFile == true)
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
                        //bool isDelete = this.fileHelper.DeleteFile(qtFileDelete, Convert.ToInt32(this.bAQD_CONGBO.LOAIANID));
                        //if (isDelete == false)
                        //{
                        //    //trong quá trình test có thể file tồn tại ở project khác
                        //    //sẽ chỉ ghi đè file và không hander error
                        //}

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

                    if (pnTenTep.Visible == true)
                    {
                        if (!String.IsNullOrEmpty(txtTenTep.Text))
                        {
                            bAQD_FILE.TENFILE = txtTenTep.Text;
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
                            lblThongbao.Text = "Thêm tệp thành công!";
                            ls.HANHDONG = "ADD_" + loaiTep;
                            ls.FILESERVER_ID_NEW = bAQD_FILE.FILESERVER_ID;
                        }
                    }
                    else
                    {
                        isUpdateDatabase = DataExtensions.Update<BAQD_FILE>(bAQD_FILE);
                        if (isUpdateDatabase)
                        {
                            lblThongbao.Text = "Lưu thành công!";
                            ls.FILESERVER_ID_NEW = bAQD_FILE.FILESERVER_ID;
                            ls.HANHDONG = "UPDATE_" + loaiTep;
                        }

                    }
                    if (!isUpdateDatabase)
                    {
                        lblThongbao.Text = "Lưu tệp không thành công. Hãy thử lại!";
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
            catch (Exception ex)
            {
                lblThongbao.Text = "Không thể tải tệp lên hệ thống";
                return;
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            rdbLoaiTep.SelectedValue = ((int)ENUM_LOAI_FILE.FILE_GOC).ToString();
            pnTenTep.Visible = false;
            rdbLoaiTep.Enabled = true;
            txtTepID.Text = null;
        }

        protected void btnCongBo_Click(object sender, EventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.CAPNHAT == false)
                {
                    lblThongbao.Text = "Bạn không có quyền cập nhật dữ liệu";
                    return;
                }
                BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {this.bAQD_CONGBO.ID} AND LOAIFILE={(int)ENUM_LOAI_FILE.FILE_DA_MA_HOA}").FirstOrDefault();
                if (bAQD_FILE == null)
                {
                    lblThongbao.Text = "Không tồn tại tệp đã mã hóa";
                    return;
                }
                this.bAQD_CONGBO.TRANGTHAI = 2;
                this.bAQD_CONGBO.NGAYSUA = DateTime.Now;
                this.bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                DataExtensions.Update<BAQD_CONGBO>(this.bAQD_CONGBO);
                BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                {
                    BAQD_CONGBO_ID = this.bAQD_CONGBO.ID,
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                    HANHDONG = "CONGBO"
                };
                ls.NGAYTAO = DateTime.Now;
                DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Công bố bản án thành công! ");
                lblThongbao.Text = "Bản án/Quyết định đã được công bố. Không cho phép sửa/xóa";
                AsyncFileUpLoad.Enabled = false;
                Cls_Comon.SetButton(btnLuu, false);
                Cls_Comon.SetButton(btnCongBo, false);
                Cls_Comon.SetButton(btnLammoi, false);
                rdbLoaiTep.Enabled = false;
                this.LoadGrid();
            }
            catch (Exception ex)
            {
                return;
            }
        }

        //[WebMethod]
        //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        //public static object DownloadFile(string hsId, int loaifile)
        //{
        //    try
        //    {
        //        hsId = HttpUtility.UrlDecode(hsId);
        //        #region check quyền
        //        decimal userId = Convert.ToDecimal(HttpContext.Current.Session[ENUM_SESSION.SESSION_USERID]);
        //        if (userId == 0)
        //            throw new MessageException("Không thể lấy file");
        //        MenuPermission oPer = Cls_Comon.GetMenuPer(HttpContext.Current.Request.Path, userId);
        //        if (oPer.XEM == false)
        //        {
        //            throw new MessageException("Không thể lấy file");
        //        }
        //        RSAHelprer rSAHelprer = HttpContext.Current.Session[ENUM_SESSION.RSA] as RSAHelprer;

        //        decimal hsID = 0;
        //        if (!String.IsNullOrEmpty(hsId))
        //        {
        //            try
        //            {
        //                hsID = Convert.ToDecimal(rSAHelprer.Decryption(hsId));
        //            }
        //            catch
        //            {
        //                throw new MessageException("Không thể lấy file");
        //            }
        //        }
        //        else
        //        {
        //            throw new MessageException("Không thể lấy file");
        //        }
        //        #endregion
        //        var loaiTep = Enum.Parse(typeof(ENUM_LOAI_FILE), loaifile.ToString());
        //        //lấy baqd_congbo của hsid
        //        BAQD_CONGBO bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(hsID);
        //        BAQD_FILE bAQD_FILE = DataExtensions.GetAllWithClause<BAQD_FILE>($"BAQD_CONGBO_ID= {bAQD_CONGBO.ID} AND LOAIFILE={Convert.ToDecimal(loaifile)}").FirstOrDefault();
        //        if (bAQD_FILE == null)
        //            throw new MessageException("Không thể lấy file");
        //        QT_FILE qT_FILE = new QT_FILE()
        //        {
        //            DATE_CREATED = bAQD_FILE.NGAYTAO,
        //            FILE_NAME = bAQD_FILE.TENFILENATIVE,
        //            ID = bAQD_FILE.FILESERVER_ID ?? 0,
        //            FILE_TYPE = bAQD_FILE.DUOIFILE.ToString()
        //        };
        //        QT_FILE_BL fileH = new QT_FILE_BL();
        //        byte[] file = fileH.GetNoiDungFile(qT_FILE, Convert.ToInt32(bAQD_CONGBO.LOAIANID));
        //        var data = new
        //        {
        //            fileResult = file,
        //            fileName = bAQD_FILE.TENFILE ?? bAQD_FILE.TENFILENATIVE,
        //            FILE_TYPE = bAQD_FILE.DUOIFILE,
        //            TroLy = HttpContext.Current.Session[ENUM_SESSION.TROLYAOINFOR] as TroLyAoInfor,
        //        };
        //        return data;
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine(ex.Message);
        //        throw new MessageException("Không thể lấy file");
        //    }
        //}
    }
}
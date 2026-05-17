using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace WEB.GSTP.QLAN
{
    public partial class CongBoBanAn : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private String VuViecTemp = "VuViecIDTemp";
        private RSAHelprer rSAHelprer;

        private string user_permission_cbba = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            /* 09.05.2025 duytm
             * Phân quyền chỉ có các chức danh được truy cập để công bố bản án:
             * 1. Thẩm phán sơ cấp
             * 2. Thẩm phán trung cấp
             * 3. Thẩm phán cao cấp
             * 4. Nhóm quyền "Quản trị hệ thống"
             * 5. Nhóm quyền "Quản trị cấp tỉnh-Quản trị CBBA"
             */

            decimal userid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            var user_permission = dt.QT_NGUOISUDUNG.Where(x => x.ID == userid).FirstOrDefault();

            if (user_permission != null)
            {
                var canbo_permission = dt.DM_CANBO.Where(x => x.ID == user_permission.CANBOID).FirstOrDefault();

                var chucdanh_permission = canbo_permission != null
                    ? dt.DM_DATAITEM.Where(x => x.ID == canbo_permission.CHUCDANHID).FirstOrDefault()
                    : null;
                var chucvu_permission = canbo_permission != null
                    ? dt.DM_DATAITEM.Where(x => x.ID == canbo_permission.CHUCVUID).FirstOrDefault()
                    : null;
                var quantri_permission = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == user_permission.NHOMNSDID).FirstOrDefault();

                var danhSachChucdanh = new[] {
                        "Thẩm phán sơ cấp",
                        "Thẩm phán trung cấp",
                        "Thẩm phán cao cấp",
                        "Thẩm phán Tòa án nhân dân bậc 1",
                        "Thẩm phán Tòa án nhân dân bậc 2",
                        "Thẩm phán Tòa án nhân dân bậc 3", 
                        "TPTATC",
                        "Thẩm phán Tòa án nhân dân tối cao"
                    };

                var danhSachChucvu = new[] {
                        "Quyền Chánh án",
                        "Phó Chánh án phụ trách",
                        "Chánh án"
                    };

                var danhSachQuantri = new[] {
                        "Quản trị hệ thống",
                        "Quản trị cấp tỉnh-Quản trị CBBA"
                    };

                // Kiểm tra null trước khi sử dụng thuộc tính TEN
                bool hasChucdanhPermission = chucdanh_permission != null && danhSachChucdanh.Contains(chucdanh_permission.TEN);
                bool hasChucvuPermission = chucvu_permission != null && danhSachChucvu.Contains(chucvu_permission.TEN);
                bool hasQuantriPermission = quantri_permission != null && danhSachQuantri.Contains(quantri_permission.TEN);

                decimal hasDonviPermission = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                if ((!hasChucdanhPermission && !hasChucvuPermission && !hasQuantriPermission) && hasDonviPermission != 1)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Tài khoản không thuộc nhóm quyền Thẩm phán, PCA, CA, Quản trị viên! " + "')", true);
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Permisson.aspx");
                }
                else
                {
                    if (hasQuantriPermission)
                        user_permission_cbba = quantri_permission.TEN;
                    else if (hasChucvuPermission)
                        user_permission_cbba = chucvu_permission.TEN;
                    else if (hasChucdanhPermission)
                        user_permission_cbba = chucdanh_permission.TEN;
                }
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
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                Session[VuViecTemp] = "";
                //LoadDropToaAn();
                LoadCombobox();
                LoadLoaiAn();
                LoadDropTrangThaiCongBo();
                InitLyDoKhongCongBo();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }

        private void InitLyDoKhongCongBo()
        {
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc được Tòa án xét xử kín", 1.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc có chứa đựng nội dung thuộc danh mục bí mật nhà nước theo quy định của Chính phủ hoặc chứa đựng những nội dung mà Nhà nước chưa công bố và nếu bị tiết lộ thì gây nguy hại cho Nhà nước Cộng hòa xã hội chủ nghĩa Việt Nam", 2.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc có chứa đựng thông tin về hoạt động đầu tư tài chính, bí quyết nghề nghiệp, công nghệ chưa được bộc lộ, có thể được sử dụng và tạo lợi thế trong kinh doanh mà trong quá trình Tòa án xét xử, giải quyết vụ việc, người tham gia tố tụng đã có yêu cầu được giữ bí mật", 3.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc có chứa đựng nội dung ảnh hưởng xấu đến truyền thống văn hóa, phong tục, tập quán tốt đẹp được thừa nhận và áp dụng rộng rãi trong một vùng, miền, dân tộc, cộng đồng dân cư.", 4.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc có người tham gia tố tụng là người dưới 18 tuổi.", 5.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("BA/QĐ về vụ việc có chứa đựng nội dung liên quan đến bí mật cá nhân, bí mật gia đình mà chưa được mã hóa theo hướng dẫn tại Điều 7 Nghị quyết 03/2017/NQ-HĐTP", 6.ToString()));
            rblKhongCongBo.Items.Add(new ListItem("Bản án, quyết định của Tòa án chưa có hiệu lực pháp luật.", 7.ToString()));

            rblKhongCongBo.SelectedIndex = 0;
        }
        
        protected void btnLamMoi_Click(object sender, EventArgs e)
        {
            rblKhongCongBo.SelectedIndex = 0;
            txtGhiChu.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
        }

        protected void btnXoaKhongCongBo_Click(object sender, EventArgs e)
        {
            #region check quyền

            decimal userId = Convert.ToDecimal(HttpContext.Current.Session[ENUM_SESSION.SESSION_USERID]);
            MenuPermission oPer = Cls_Comon.GetMenuPer(HttpContext.Current.Request.FilePath, userId);
            if (oPer.CAPNHAT == false)
            {
                lblThongbao.Text = "Bạn không có quyển cập nhật";
                ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                return;
            }
            RSAHelprer rSAHelprer = HttpContext.Current.Session[ENUM_SESSION.RSA] as RSAHelprer;

            decimal hsID = 0;
            if (!String.IsNullOrEmpty(txtCongBoID.Value))
            {
                try
                {
                    hsID = Convert.ToDecimal(rSAHelprer.Decryption(txtCongBoID.Value));
                }
                catch
                {
                    lblThongbao.Text = "Không thể thực hiện";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
            }
            else
            {
                lblThongbao.Text = "Không thể thực hiện";
                ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                return;
            }

            #endregion check quyền

            BAQD_CONGBO bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(hsID);
            if (bAQD_CONGBO != null)
            {
                if (bAQD_CONGBO.TRANGTHAI != 3)
                {
                    lblThongbao.Text = "Chỉ ở trạng thái không công bố mới được xóa";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
                bAQD_CONGBO.TRANGTHAI = null;
                bAQD_CONGBO.LYDOTUCHOI = null;
                bAQD_CONGBO.GHICHU = null;
                bAQD_CONGBO.NGAYSUA = DateTime.Now;
                bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                bool result = DataExtensions.Update(bAQD_CONGBO);
                if (result)
                {
                    BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                    {
                        BAQD_CONGBO_ID = bAQD_CONGBO.ID,
                        NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                        HANHDONG = "DELETE_KHONGCONGBO",
                        NGAYTAO = DateTime.Now,
                    };
                    DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                    lblThongbao.Text = "Xóa không công bố thành công";
                    this.Load_Data();
                    btnLuu.Visible = false;
                    btnXoaKhongCongBo.Visible = false;
                    btnLamMoi.Visible = false;
                    this.btnLamMoi_Click(null, null);
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
            }
            lblThongbao.Text = "Thao tác thất bại hãy thức hiện lại.";
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            #region check quyền

            decimal userId = Convert.ToDecimal(HttpContext.Current.Session[ENUM_SESSION.SESSION_USERID]);
            MenuPermission oPer = Cls_Comon.GetMenuPer(HttpContext.Current.Request.FilePath, userId);
            if (oPer.CAPNHAT == false)
            {
                lblThongbao.Text = "Bạn không có quyển cập nhật";
                ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                return;
            }
            RSAHelprer rSAHelprer = HttpContext.Current.Session[ENUM_SESSION.RSA] as RSAHelprer;

            decimal hsID = 0;
            if (!String.IsNullOrEmpty(txtCongBoID.Value))
            {
                try
                {
                    hsID = Convert.ToDecimal(rSAHelprer.Decryption(txtCongBoID.Value));
                }
                catch
                {
                    lblThongbao.Text = "Không thể thực hiện";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
            }
            else
            {
                lblThongbao.Text = "Không thể thực hiện";
                ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                return;
            }

            #endregion check quyền

            BAQD_CONGBO bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(hsID);
            if (bAQD_CONGBO != null)
            {
                if (bAQD_CONGBO.TRANGTHAI != null && bAQD_CONGBO.TRANGTHAI != 1 && bAQD_CONGBO.TRANGTHAI != 3)
                {
                    lblThongbao.Text = "Bản án đã được công bố hoặc không công bố. Không được cập nhật";
                    btnLuu.CssClass = "aspNetDisabled buttondisable";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
                BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                {
                    BAQD_CONGBO_ID = bAQD_CONGBO.ID,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                };
                if (bAQD_CONGBO.TRANGTHAI == 3)
                {
                    ls.HANHDONG = "UPDATE_KHONGCONGBO";
                }
                else
                {
                    ls.HANHDONG = "KHONGCONGBO";
                }
                bAQD_CONGBO.TRANGTHAI = 3;
                try
                {
                    bAQD_CONGBO.LYDOTUCHOI = Convert.ToDecimal(rblKhongCongBo.SelectedValue);
                }
                catch
                {
                    lblTitleModal.Text = "Lý do không tồn tại";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
                    return;
                }
                bAQD_CONGBO.GHICHU = txtGhiChu.Text;
                bAQD_CONGBO.NGAYSUA = DateTime.Now;
                bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                bool result = DataExtensions.Update(bAQD_CONGBO);
                if (result)
                {
                    ls.NGAYTAO = DateTime.Now;
                    DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);
                    lblThongbao.Text = "Cập nhật thành công";
                    this.Load_Data();
                    btnLuu.Visible = true;
                    btnLamMoi.Visible = false;
                    btnXoaKhongCongBo.Visible = true;
                    lblTitleModal.Text = "Lý do không công bố";
                    ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnUpdateDone", "OnUpdateDone()", true);
                    return;
                }
            }
            lblThongbao.Text = "Thao tác thất bại hãy thức hiện lại.";
            ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowModal", "OnShowModal()", true);
        }

        private void LoadDropTrangThaiCongBo()
        {
            ddlTrangThaiCongBo.Items.Clear();
            ddlTrangThaiCongBo.Items.Add(new ListItem("Tất cả", ""));
            ddlTrangThaiCongBo.Items.Add(new ListItem("Chưa công bố", "1"));
            ddlTrangThaiCongBo.Items.Add(new ListItem("Đã công bố", "2"));
            ddlTrangThaiCongBo.Items.Add(new ListItem("Không công bố", "3"));
            ddlTrangThaiCongBo.Items.Add(new ListItem("Hạ/Hủy/Gỡ công bố", "4"));
            ddlTrangThaiCongBo.SelectedIndex = 1;
        }

        private void LoadLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));
            ddlLoaiAn.Items.Add(new ListItem("Biện pháp xử lý hành chính", ENUM_LOAIVUVIEC_NUMBER.BPXLHC));
            ddlLoaiAn.SelectedValue = "1";
        }
       
        private void ClearSession_TK()
        {
            Session[TK_CANHBAO.TENVUVIEC] = "";
            Session[TK_CANHBAO.TOIDANH] = "";
            Session[TK_CANHBAO.MANVUVIEC] = "";
            Session[TK_CANHBAO.BiCan] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TOAAN] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.SOTHULY] = "";
            Session[TK_CANHBAO.NGAYTHULY_TU] = "";
            Session[TK_CANHBAO.NGAYTHULY_DEN] = "";
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.DENNGAY] = "";
            Session[TK_CANHBAO.KETQUA] = "";
            Session[TK_CANHBAO.SOQD] = "";
            Session[TK_CANHBAO.NGAYQD] = "";
            Session[TK_CANHBAO.THAMPHAN] = "";
            Session[TK_CANHBAO.THUKY] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.TAMGIAM] = "";
            Session[TK_CANHBAO.UTTP] = "";
            Session[TK_CANHBAO.LOAIAN] = "";
            Session[SS_TK.ARRSELECTID] = "";
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ClearSession_TK();
            ddlLoaiAn.SelectedValue = "1";
            txtTenVuViec.Text = string.Empty;
            txt_toidanh.Text = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
        }

        private void LoadCombobox()
        {
            dropCapxx.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Giám đốc thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
                dropCapxx.Items.Add(new ListItem("Tái thẩm", ENUM_GIAIDOANVUAN.THULYTT.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Giám đốc thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
                dropCapxx.Items.Add(new ListItem("Tái thẩm", ENUM_GIAIDOANVUAN.THULYTT.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "TOICAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Giám đốc thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
                dropCapxx.Items.Add(new ListItem("Tái thẩm", ENUM_GIAIDOANVUAN.THULYTT.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Giám đốc thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
                dropCapxx.Items.Add(new ListItem("Tái thẩm", ENUM_GIAIDOANVUAN.THULYTT.ToString()));
            }

            LoadDropThamphan();
            //LoadDrop_TTV_TK();
        }

        private void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
            if (oCB != null)
            {
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.TEN.Contains("Thẩm phán"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.TEN.Contains("Chánh án"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }

        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
        }

        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            Load_Data();
        }

        private void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("-- Tất cả --", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        private void Load_Data()
        {
            CONGBO_BL obj = new CONGBO_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable tbl = obj.GetAllPaging_Search_All(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), null/*txtMaVuViec.Text.Trim()*/, null/*txtBiCan.Text.Trim()*/, dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + ""/*DropToaAn.SelectedValue*/,
                                            null, "","","",/*txtThuly_So.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text,*/
                                            null, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), null, txtSoQD.Text.Trim(),
                                            null, ddlThamphan.SelectedValue, null/*ddlHTND_Thuky.SelectedValue*/, null, "", null, ddlLoaiAn.SelectedValue, ddlTrangThaiCongBo.SelectedValue, pageindex, page_size);

            DataTable dtCloned = tbl.Clone();
            dtCloned.Columns[0].DataType = typeof(Int32);

            foreach (DataColumn dc in dtCloned.Columns)
            {
                if (dc.ColumnName.Equals("ID") || dc.ColumnName.Equals("BAQD_CONGBO_ID"))
                {
                    dc.DataType = typeof(string);
                }
            }

            foreach (DataRow dtRow in tbl.Rows)
            {
                dtCloned.ImportRow(dtRow);
            }

            foreach (DataRow dtRow in dtCloned.Rows)
            {
                foreach (DataColumn dc in dtCloned.Columns)
                {
                    if (dc.ColumnName.Equals("ID") || dc.ColumnName.Equals("BAQD_CONGBO_ID"))
                    {
                        dtRow[dc] = this.rSAHelprer.Encryption(dtRow[dc].ToString());
                    }
                }
            }

            if (dtCloned.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(dtCloned.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = dtCloned;
            dgList.DataBind();
        }

        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                UpdatePanel pnMaHoaChiTiet = (UpdatePanel)e.Item.FindControl("pnMaHoaChiTiet");
                Button pnLyDoKhongCongBo = (Button)e.Item.FindControl("lblLyDoKhongCongBo");
                Button pnKhongCongBo = (Button)e.Item.FindControl("btnKhongCongBo");
                Button btnHaCongbo = (Button)e.Item.FindControl("btnHaCongbo");

                if (oPer.CAPNHAT == false)
                {
                    pnKhongCongBo.Visible = false;
                }
                DataRowView row = (DataRowView)e.Item.DataItem;
                string tt = row["TT_CB_ID"].ToString();
                decimal? trangThai = 0;

                if (!String.IsNullOrEmpty(tt))
                {
                    trangThai = Convert.ToDecimal(tt);

                    if (trangThai == 1)
                    {
                        pnKhongCongBo.Visible = true;
                        pnMaHoaChiTiet.Visible = true;
                    }
                    if (trangThai == 2)
                    {
                        pnKhongCongBo.Visible = false;
                    }
                    if (trangThai == 3)
                    {
                        pnLyDoKhongCongBo.Visible = true;
                        pnKhongCongBo.Visible = false;
                        pnMaHoaChiTiet.Visible = false;
                    }
                    if (trangThai == 4)
                    {
                        pnLyDoKhongCongBo.Visible = false;
                        pnKhongCongBo.Visible = true;
                        pnMaHoaChiTiet.Visible = true;
                    }
                }
                else
                {
                    pnKhongCongBo.Visible = true;
                    pnMaHoaChiTiet.Visible = true;
                }

                /* Chánh án đơn vị và IT cấp tỉnh được phân quyền thực hiện hạ bản án trên QLTA */
                var danhSachCoQuyenHaCongbo = new[] { "Quản trị hệ thống", "Quản trị cấp tỉnh-Quản trị CBBA", "Chánh án" };
                if (danhSachCoQuyenHaCongbo.Contains(user_permission_cbba) && trangThai == 2) // Quản trị cấp tỉnh
                {
                    btnHaCongbo.Visible = true;
                }
                else
                {
                    btnHaCongbo.Visible = false;
                }
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                RSAHelprer rSAHelprer = HttpContext.Current.Session[ENUM_SESSION.RSA] as RSAHelprer;

                decimal hsID = 0;
                if (!String.IsNullOrEmpty(e.CommandArgument.ToString()))
                {
                    try
                    {
                        hsID = Convert.ToDecimal(rSAHelprer.Decryption(e.CommandArgument.ToString()));
                    }
                    catch
                    {
                        lblThongbao.Text = "Không thể thực hiện";
                        return;
                    }
                }
                else
                {
                    lblThongbao.Text = "Không thể thực hiện";
                    return;
                }
                BAQD_CONGBO bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(hsID);
                if (bAQD_CONGBO == null)
                {
                    lblThongbao.Text = "Không thể thực hiện";
                    return;
                }
                int PUBLIC_JUDGMENT_ID = 0;
                switch (e.CommandName)
                {
                    case "btnHaCongbo":

                        BAQD_CONGBO_LICHSU ls = new BAQD_CONGBO_LICHSU()
                        {
                            BAQD_CONGBO_ID = bAQD_CONGBO.ID,
                            NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                            HANHDONG = "HA_HUY_CONGBO",
                            NGAYTAO = DateTime.Now,
                        };
                        DataExtensions.Insert<BAQD_CONGBO_LICHSU>(ls);

                        PUBLIC_JUDGMENT_ID = Convert.ToInt32(bAQD_CONGBO.PUBLIC_JUDGMENT_ID);
                        string EDITUSER = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            
                        var Public_JudgmentUpdateStatus = new Public_JudgmentUpdateStatusDto
                        {
                            Id = PUBLIC_JUDGMENT_ID,
                            Status = 2, /* 0 - Chưa đăng * 1 - Đã Công bố * 2 - Đã Hạ */
                            EditUser = EDITUSER
                        };
                        string jsonString = JsonConvert.SerializeObject(Public_JudgmentUpdateStatus);
                        decimal? validate_cbba = CallApiCBBA.Update_Status(jsonString).GetAwaiter().GetResult();
                        if(validate_cbba == 0 || validate_cbba == null)
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lỗi khi hạ công bố BA/QĐ!')", true);
                            return;
                        }    

                        bAQD_CONGBO.TRANGTHAI = 4;
                        DataExtensions.Update(bAQD_CONGBO);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Hạ công bố BA/QĐ thành công! " + "')", true);
                        break;

                    case "btnLyDoKhongCongBo":
                        lblTitleModal.Text = "Lý do không công bố";
                        btnLamMoi.Visible = false;
                        btnXoaKhongCongBo.Visible = true;
                        btnLuu.Visible = true;
                        lblThongbao.Text = "";
                        rblKhongCongBo.SelectedValue = bAQD_CONGBO.LYDOTUCHOI.ToString();
                        txtGhiChu.Text = bAQD_CONGBO.GHICHU;
                        txtCongBoID.Value = e.CommandArgument.ToString();
                        ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowLyDoKhongCongBo", "OnShowLyDoKhongCongBo()", true);
                        break;

                    case "btnKhongCongBo":
                        this.btnLamMoi_Click(null, null);
                        lblTitleModal.Text = "Không công bố";
                        btnLamMoi.Visible = true;
                        btnLuu.Visible = true;
                        btnXoaKhongCongBo.Visible = false;
                        lblThongbao.Text = "";
                        rblKhongCongBo.SelectedIndex = 0;
                        txtGhiChu.Text = "";
                        txtCongBoID.Value = e.CommandArgument.ToString();
                        ScriptManager.RegisterStartupScript(this.Page, GetType(), "OnShowKhongCongBo", "OnShowKhongCongBo()", true);
                        break;

                    default:
                        break;
                }

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + ex.Message + "')", true);
            }
        }
        

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion "Phân trang"
        

    }
}
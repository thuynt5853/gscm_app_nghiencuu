using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.DLQGC12;
using BL.GSTP.THA;
using BL.GSTP.THA.Model;
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

namespace WEB.GSTP.QLAN.THA.DongBo
{
    public partial class DongBoDLDCQG : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    LoadDropToaAn();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            DropToaAn.DataTextField = "arrTEN";
            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }
        }

        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
        }

        private void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------

            LoadDropThamphan();
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkChon = (CheckBox)sender;

            if (chkChon != null && chkChon.Checked)
            {
                string input = chkChon.ToolTip;
                string[] array = input.Split(',');
                if (array.Length < 4)
                {
                    return;
                }

                string trangThaiBanAn = array[3]; //trạng thái bản án

                // nếu bản án đã đồng bộ (tất cả đã đồng bộ)
                if (trangThaiBanAn == "2")
                {
                    pn_thuhoi.Visible = true;
                }
                else
                {
                    pn_thuhoi.Visible = false;
                }
            }

            foreach (DataGridItem row in dgList.Items)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkChon");
                if (cb != null && cb != chkChon)
                {
                    cb.Checked = false;
                }
            }
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {

            }
        }

        protected void ddlTrangthaiDongBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            pn_thuhoi.Visible = false;
            LoadGrid();
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtMaVuAn.Text = "";
            dropCapxx.SelectedValue = "";
            DropToaAn.SelectedValue = "";
            txtTenVuAn.Text = "";
            ddlLoaiQuyetDinh.SelectedValue = "1";
            txtToidanh.Text = "";
            txtBican.Text = "";
            txtCCCD.Text = "";
            txtSoQuyetDinh.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";

            ddlTrangthaiDongBo.SelectedValue = "0";
            ddlThamphan.SelectedValue = "";
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void dgList_ItemCommand(object sender, DataGridCommandEventArgs e)
        {
            DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();

            string input = e.CommandArgument.ToString();
            string[] array = input.Split(',');
            string ID = array[0];
            string LoaiQDID = array[1];
            string khoQDId = array[2];

            switch (e.CommandName)
            {
                case "GuiLai":
                    if (!oBL.IsExsistKHOBIANQUYETDINH(ID, LoaiQDID))
                    {
                        return;
                    }

                    GuiLai(khoQDId, ID, LoaiQDID);
                    break;
                case "HuyChuyen":
                    if (!oBL.IsExsistKHOBIANQUYETDINH(ID, LoaiQDID))
                    {
                        return;
                    }
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(khoQDId, out success, out fail);
                    if (success > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                    }
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    break;
                case "View":
                    if (!oBL.IsExsistKHOBIANQUYETDINH(ID, LoaiQDID))
                    {
                        return;
                    }
                    string StrMsg = "PopupCenter('/QLAN/THA/DongBo/LichSuDongBo.aspx?KHOBAQDID=" + khoQDId.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }

        protected void GuiLai(string vDongBoID, string idQD, string LoaiQDID)
        {
            DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();
            decimal vCount = 0;

            DataTable tbl = oBL.GetTHAPaging(null, null, null, LoaiQDID, null, null, null, null, null, null, null, null, null, idQD, 1, 1);

            if (tbl.Rows.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được quyết định');", true);
                return;
            }

            DataRow row = tbl.Rows[0];
            DateTime ngaySinh;
            DateTime.TryParseExact(row["NgaySinh"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngaySinh);

            DateTime ngayQd;
            DateTime.TryParseExact(row["NgayQdinh"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayQd);

            DateTime ngayBA;
            DateTime.TryParseExact(row["NGAYBANAN"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayBA);

            DateTime ngayTHA;
            DateTime.TryParseExact(row["NGAYBANAN"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayTHA);

            #region lấy tình trạng bị án
            string tinhTrangBiAn = string.Empty;
            if (!string.IsNullOrEmpty(row["TINHTRANG_BIAN"] + ""))
            {
                DataTable data = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.AHS_TINHTRANGBIAN);
                foreach (DataRow item in data.Rows)
                {
                    if ((item["MA"] + "") == (row["TINHTRANG_BIAN"] + "")) tinhTrangBiAn = item["TEN"] + "";
                    break;
                }
            }
            #endregion

            #region lấy danh sách hình phạt
            DataTable dsHinhPhat = new DataTable();
            if (row["MAGIAIDOAN"] + "" == "2")
                dsHinhPhat = oBL.Tonghophinhphat_ST((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
            else
                dsHinhPhat = oBL.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);

            HinhPhatModel hinhPhatChinh = new HinhPhatModel();
            string hinhPhatBS = string.Empty;
            if (dsHinhPhat != null && dsHinhPhat.Rows.Count > 0)
                foreach (DataRow item in dsHinhPhat.Rows)
                {
                    if (item["ISMAIN"] + "" == "1")
                    {
                        hinhPhatChinh = new HinhPhatModel()
                        {
                            maHinhPhat = item["MAHINHPHAT"] + "",
                            tenHinhPhat = item["TENHINHPHAT"] + "",
                            thamSoHinhPhat = thamSoHinhPhat(item)
                        };
                    }
                    else
                    {
                        hinhPhatBS += "<dsachHinhPhatBs>" +
                                            $"<maHinhPhatBs>{item["MAHINHPHAT"] + ""}</maHinhPhatBs>" +
                                            $"<tenHinhPhatBs>{item["TENHINHPHAT"] + ""}</tenHinhPhatBs>" +
                                            $"<thamSoHinhPhat>{thamSoHinhPhat(item)}</thamSoHinhPhat>" +
                                      "</dsachHinhPhatBs>";
                    }
                }
            #endregion

            #region lấy danh sách tội danh và hình phạt
            string dsachToiDanh = string.Empty;
            DLQGC12_AHS_BL ahsBl = new DLQGC12_AHS_BL();
            DataTable toiDanh = ahsBl.GET_TOIDANH_BY_BICAO(Convert.ToDecimal(row["BIANID"] ?? 0), row["MAGIAIDOAN"] + "", "1");
            if (toiDanh.Rows.Count > 0)
            {
                List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();

                foreach (DataRow rows in toiDanh.Rows)
                {
                    dsachToiDanh += "<dsachToiDanh>" +
                                            $"<maToiDanh>{rows["ID"] + ""}</maToiDanh>" +
                                            $"<tenToiDanh>{rows["TENTOIDANH"] + ""}</tenToiDanh>";

                    #region lấy hình phạt theo tội danh của bị án
                    DataTable dsHinhPhatTbl = ahsBl.GET_HINHPHAT_BY_TOIDANH_BICAO(Convert.ToDecimal(row["BIANID"] ?? 0), Convert.ToDecimal(rows["ID"] ?? 0), row["MAGIAIDOAN"] + "", "1");
                    if (dsHinhPhatTbl.Rows.Count > 0)
                    {
                        foreach (DataRow hp in dsHinhPhatTbl.Rows)
                        {
                            dsachToiDanh += "<dsachHinhPhat>" +
                                                $"<maHinhPhat>{hp["MAHINHPHAT"] + ""}</maHinhPhat>" +
                                                $"<tenHinhPhat>{hp["TENHINHPHAT"] + ""}</tenHinhPhat>" +
                                                $"<thamSoHinhPhat>{thamSoHinhPhat(hp)}</thamSoHinhPhat>" +
                                                $"<hinhPhatChinh>{hp["ISCHANGE"] + ""}</hinhPhatChinh>" +
                                            "</dsachHinhPhat>";
                        }
                    }
                    #endregion
                    dsachToiDanh += "</dsachToiDanh>";
                }
            }
            #endregion

            KhoBiAnQuyetDinhModel obj = new KhoBiAnQuyetDinhModel()
            {
                KHOBIAN_QUYETDINHID = !string.IsNullOrEmpty(vDongBoID) ? decimal.Parse(vDongBoID) : (decimal?)null,

                SODINHDANH = row["SoDinhDanh"] + "",
                HOVATEN = row["HoVaTen"] + "",
                NGAYSINH = ngaySinh,
                GIOITINH = row["GioiTinh"] == DBNull.Value ? (int?)null : int.Parse(row["GioiTinh"] + ""),
                NOIDKKS = row["NOIDKKS"] + "",
                NOIDKKSMATINH = row["NOIDKKSMATINH"] + "",
                NOIDKKSTINH = row["NOIDKKSTINH"] + "",
                NOIDKKSMAXA = row["NOIDKKSMAXA"] + "",
                NOIDKKSXA = row["NOIDKKSXA"] + "",
                NOICUTRU = row["NoiCuTru"] + "",
                NOICUTRUMATINH = row["NoiCuTruMaTinh"] + "",
                NOICUTRUTINH = row["NoiCuTruTinh"] + "",
                NOICUTRUMAXA = row["NoiCuTruMaXa"] + "",
                NOICUTRUXA = row["NoiCuTruXa"] + "",
                SOHOCHIEU = row["SOHOCHIEU"] + "",
                HOTENCHA = row["HOTENCHA"] + "",
                HOTENME = row["HOTENME"] + "",
                HOTENVOCHONG = row["HOTENVOCHONG"] + "",
                IDQD = row["ID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["ID"] + ""),
                LOAIQUYETDINH = row["LoaiQDID"] == DBNull.Value ? (int?)null : int.Parse(row["LoaiQDID"] + ""),
                LOAIQUYETDINHTEN = row["LoaiQD"] + "",
                SOQDINH = row["SoQdinh"] + "",
                NGAYQDINH = ngayQd,
                MADVI = row["MaDvi"] + "",
                TENDVI = row["TenDvi"] + "",
                TRICHYEUNOIDUNG = row["TrichYeuNoiDung"] + "",
                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",

                SOBANAN = row["SOBANAN"] + "",
                NGAYBANAN = ngayBA,
                MADONVIBANAN = row["MaDonViBanAn"] + "",
                TENDONVIBANAN = row["TenDonViBanAn"] + "",
                DANHSACHTOIDANH = dsachToiDanh,
                HINHPHATCHINH = hinhPhatChinh.tenHinhPhat,
                MAHINHPHATCHINH = hinhPhatChinh.maHinhPhat,
                TENHINHPHATCHINH = hinhPhatChinh.tenHinhPhat,
                THAMSOHINHPHAT = hinhPhatChinh.thamSoHinhPhat,
                DANHSACHHINHPHATBS = hinhPhatBS,
                TINHTRANGTHA = tinhTrangBiAn,
                NGAYTHA = ngayTHA,
                MANOITHA = row["MANOICHAPHANHAN"] + "",
                TENNOITHA = row["NOICHAPHANHAN"] + "",
                TRANGTHAITHA = row["TRANGTHAITHA"] + "",
                BIANID = row["BIANID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["BIANID"] + ""),
                THABIANID = row["THABIANID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["THABIANID"] + ""),
            };

            if (obj == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không tìm thấy bản ghi');", true);
                return;
            }

            if (oBL.GuiLai_DuLieu_DongBo(obj))
            {
                vCount++;
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                return;
            }

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);
            LoadGrid();
        }

        protected void btnThuHoi_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();
            decimal vCount = 0;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                    string input = chkChon.ToolTip;
                    string[] array = input.Split(',');

                    if (array.Length < 4)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được quyết định');", true);
                        return;
                    }

                    string kHOBIAN_QUYETDINH_ID = array[2];

                    DataTable tbl = oBL.GetByIdKHOBIAN_QUYETDINH(kHOBIAN_QUYETDINH_ID);

                    decimal id;

                    decimal.TryParse(kHOBIAN_QUYETDINH_ID, out id);

                    if (tbl == null || tbl.Rows.Count == 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Kho bị án quyết định không tồn tại');", true);
                        return;
                    }

                    DataRow row = tbl.Rows[0];

                    int? TRANGTHAIQD = row["TRANGTHAIQD"] == DBNull.Value ? (int?)null : int.Parse(row["TRANGTHAIQD"] + "");

                    // nếu trạng thái bản án là đã đồng bộ thì được phép thu hồi
                    if (TRANGTHAIQD == 2)
                    {
                        //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                        if (oBL.ThuHoi_DuLieu_DongBo(id, Session[ENUM_SESSION.SESSION_USERNAME] + "", txtLyDoThuHoi.Text?.Trim()))
                        {
                            vCount++;
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    else // Nếu chưa đồng bộ thì hủy chuyển
                    {
                        // trạng thái bản án đang ở chờ thu hồi
                        if (TRANGTHAIQD == 3)
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu quyết định đã được thu hồi, không thể thu hồi tiếp');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                        }
                    }
                }
                if (vCount > 0)
                {
                    txtLyDoThuHoi.Text = "";
                    hddPageIndex.Value = "1";
                }
            }

            LoadGrid();

        }

        protected void HuyChuyen(string idString, out decimal vCountSuccess, out decimal vCountFail)
        {
            vCountSuccess = 0;
            vCountFail = 0;

            //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
            DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();
            // Lấy dữ liệu từ DB

            DataTable tbl = oBL.GetByIdKHOBIAN_QUYETDINH(idString);

            decimal id;

            decimal.TryParse(idString, out id);

            if (tbl == null || tbl.Rows.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Kho bị án quyết định không tồn tại');", true);
                return;
            }

            DataRow row = tbl.Rows[0];

            int? TRANGTHAIQD = row["TRANGTHAIQD"] == DBNull.Value ? (int?)null : int.Parse(row["TRANGTHAIQD"] + "");

            // nếu đang ở trạng thái chờ đồng bộ thì được phép hủy chuyển
            if (TRANGTHAIQD == 0)
            {
                if (oBL.HuyChuyen_DuLieu_DongBo(id)) //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                {
                    //Thong bao thu hoi thanh cong
                    vCountSuccess++;
                }
                else
                {
                    vCountFail++;
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển không thành công!');", true);
                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
            }
        }

        protected void btnDongBoDuLieu_Click(object sender, EventArgs e)
        {
            int vCount = 0;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon == null || !chkChon.Checked)
                {
                    continue;
                }

                string input = chkChon.ToolTip;
                string[] array = input.Split(',');

                if (array.Length < 4)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được quyết định');", true);
                    return;
                }

                string ID = array[0];
                string LoaiQDID = array[1];

                // Lấy dữ liệu từ DB
                DongBoDLDCQG_BL oBL = new DongBoDLDCQG_BL();
                DataTable tbl = oBL.GetTHAPaging(null, null, null, LoaiQDID, null, null, null, null, null, null, null, null, null, ID, 1, 1);

                if (tbl.Rows.Count == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được quyết định');", true);
                    return;
                }

                DataRow row = tbl.Rows[0];
                DateTime ngaySinh;
                DateTime.TryParseExact(row["NgaySinh"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngaySinh);

                DateTime ngayQd;
                DateTime.TryParseExact(row["NgayQdinh"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayQd);

                DateTime ngayBA;
                DateTime.TryParseExact(row["NGAYBANAN"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayBA);

                DateTime ngayTHA;
                DateTime.TryParseExact(row["NGAYBANAN"] + "", "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out ngayTHA);
                
                #region lấy danh sách hình phạt
                DataTable dsHinhPhat = new DataTable();
                if (row["MAGIAIDOAN"] + "" == "2")
                    dsHinhPhat = oBL.Tonghophinhphat_ST((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                else
                    dsHinhPhat = oBL.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);

                HinhPhatModel hinhPhatChinh = new HinhPhatModel();
                string hinhPhatBS = string.Empty;
                if (dsHinhPhat != null && dsHinhPhat.Rows.Count > 0)
                    foreach (DataRow item in dsHinhPhat.Rows)
                    {
                        if (item["ISMAIN"] + "" == "1")
                        {
                            hinhPhatChinh = new HinhPhatModel()
                            {
                                maHinhPhat = item["MAHINHPHAT"] + "",
                                tenHinhPhat = item["TENHINHPHAT"] + "",
                                thamSoHinhPhat = thamSoHinhPhat(item)
                            };
                        }
                        else
                        {
                            hinhPhatBS += "<dsachHinhPhatBs>" +
                                                $"<maHinhPhatBs>{item["MAHINHPHAT"] + ""}</maHinhPhatBs>" +
                                                $"<tenHinhPhatBs>{item["TENHINHPHAT"] + ""}</tenHinhPhatBs>" +
                                                $"<thamSoHinhPhat>{thamSoHinhPhat(item)}</thamSoHinhPhat>" +
                                          "</dsachHinhPhatBs>";
                        }
                    }
                #endregion

                #region lấy danh sách tội danh và hình phạt
                string dsachToiDanh = string.Empty;
                DLQGC12_AHS_BL ahsBl = new DLQGC12_AHS_BL();
                DataTable toiDanh = ahsBl.GET_TOIDANH_BY_BICAO(Convert.ToDecimal(row["BIANID"] ?? 0), row["MAGIAIDOAN"] + "", "1");
                if (toiDanh.Rows.Count > 0)
                {
                    List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();

                    foreach (DataRow rows in toiDanh.Rows)
                    {
                        dsachToiDanh += "<dsachToiDanh>" +
                                                $"<maToiDanh>{rows["ID"] + ""}</maToiDanh>" +
                                                $"<tenToiDanh>{rows["TENTOIDANH"] + ""}</tenToiDanh>";

                        #region lấy hình phạt theo tội danh của bị án
                        DataTable dsHinhPhatTbl = ahsBl.GET_HINHPHAT_BY_TOIDANH_BICAO(Convert.ToDecimal(row["BIANID"] ?? 0), Convert.ToDecimal(rows["ID"] ?? 0), row["MAGIAIDOAN"] + "", "1");
                        if (dsHinhPhatTbl.Rows.Count > 0)
                        {
                            foreach (DataRow hp in dsHinhPhatTbl.Rows)
                            {
                                dsachToiDanh += "<dsachHinhPhat>" +
                                                    $"<maHinhPhat>{hp["MAHINHPHAT"] + ""}</maHinhPhat>" +
                                                    $"<tenHinhPhat>{hp["TENHINHPHAT"] + ""}</tenHinhPhat>" +
                                                    $"<thamSoHinhPhat>{thamSoHinhPhat(hp)}</thamSoHinhPhat>" +
                                                    $"<hinhPhatChinh>{hp["ISCHANGE"] + ""}</hinhPhatChinh>" +
                                                "</dsachHinhPhat>";
                            }
                        }
                        #endregion
                        dsachToiDanh += "</dsachToiDanh>";
                    }
                }
                #endregion

                KhoBiAnQuyetDinhModel obj = new KhoBiAnQuyetDinhModel()
                {
                    SODINHDANH = row["SoDinhDanh"] + "",
                    HOVATEN = row["HoVaTen"] + "",
                    NGAYSINH = ngaySinh,
                    GIOITINH = row["GioiTinh"] == DBNull.Value ? (int?)null : int.Parse(row["GioiTinh"] + ""),
                    NOIDKKS = row["NOIDKKS"] + "",
                    NOIDKKSMATINH = row["NOIDKKSMATINH"] + "",
                    NOIDKKSTINH = row["NOIDKKSTINH"] + "",
                    NOIDKKSMAXA = row["NOIDKKSMAXA"] + "",
                    NOIDKKSXA = row["NOIDKKSXA"] + "",
                    NOICUTRU = row["NoiCuTru"] + "",
                    NOICUTRUMATINH = row["NoiCuTruMaTinh"] + "",
                    NOICUTRUTINH = row["NoiCuTruTinh"] + "",
                    NOICUTRUMAXA = row["NoiCuTruMaXa"] + "",
                    NOICUTRUXA = row["NoiCuTruXa"] + "",
                    SOHOCHIEU = row["SOHOCHIEU"] + "",
                    HOTENCHA = row["HOTENCHA"] + "",
                    HOTENME = row["HOTENME"] + "",
                    HOTENVOCHONG = row["HOTENVOCHONG"] + "",
                    IDQD = row["ID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["ID"] + ""),
                    LOAIQUYETDINH = row["LoaiQDID"] == DBNull.Value ? (int?)null : int.Parse(row["LoaiQDID"] + ""),
                    LOAIQUYETDINHTEN = row["LoaiQD"] + "",
                    SOQDINH = row["SoQdinh"] + "",
                    NGAYQDINH = ngayQd,
                    MADVI = row["MaDvi"] + "",
                    TENDVI = row["TenDvi"] + "",
                    TRICHYEUNOIDUNG = row["TrichYeuNoiDung"] + "",
                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",

                    SOBANAN = row["SOBANAN"] + "",
                    NGAYBANAN = ngayBA,
                    MADONVIBANAN = row["MaDonViBanAn"] + "",
                    TENDONVIBANAN = row["TenDonViBanAn"] + "",
                    DANHSACHTOIDANH = dsachToiDanh,
                    HINHPHATCHINH = hinhPhatChinh.tenHinhPhat,
                    MAHINHPHATCHINH = hinhPhatChinh.maHinhPhat,
                    TENHINHPHATCHINH = hinhPhatChinh.tenHinhPhat,
                    THAMSOHINHPHAT = hinhPhatChinh.thamSoHinhPhat,
                    DANHSACHHINHPHATBS = hinhPhatBS,
                    TINHTRANGTHA = row["TINHTRANG_BIAN"] + "",
                    NGAYTHA = ngayTHA,
                    MANOITHA = row["MANOICHAPHANHAN"] + "",
                    TENNOITHA = row["NOICHAPHANHAN"] + "",
                    TRANGTHAITHA = row["TRANGTHAITHA"] + "",
                    BIANID = row["BIANID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["BIANID"] + ""),
                    THABIANID = row["THABIANID"] == DBNull.Value ? (decimal?)null : decimal.Parse(row["THABIANID"] + ""),
                };

                if (obj == null)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không tìm thấy bản ghi');", true);
                    return;
                }

                if (oBL.IsExsistKHOBIANQUYETDINH(ID, LoaiQDID))
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Quyết định đã tồn tại trong kho quyết định');", true);
                    return;
                }

                else if (oBL.Insert_DuLieu_DongBo(obj))
                {
                    vCount = vCount + 1; //Add các doi tuong vao mang de thuc hien insert
                }
            }

            if (vCount > 0)
            {
                hddPageIndex.Value = "1";
                LoadGrid();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
                return;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton LinkButtonXemLichSu = (LinkButton)e.Item.FindControl("LinkButtonXemLichSu");
                LinkButton LinkButtonXemGuiLai = (LinkButton)e.Item.FindControl("LinkButtonXemGuiLai");
                LinkButton LinkButtonHuyChuyen = (LinkButton)e.Item.FindControl("LinkButtonHuyChuyen");

                switch (ddlTrangthaiDongBo.SelectedValue)
                {
                    // chưa đồng bộ
                    case "0":
                        LinkButtonXemLichSu.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;
                        break;
                    // đã đồng bộ
                    case "3":
                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = true;
                        break;
                    // đã đồng bộ
                    case "1":
                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;

                        object value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIQD");

                        int soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        if (soDs == 0)
                        {
                            LinkButtonHuyChuyen.Visible = true;
                        }
                        break;
                    // thu hồi
                    case "2":

                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonHuyChuyen.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIQD");

                        soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        // nếu đã thu hồi thì được phép gửi lại
                        if (soDs == 5)
                        {
                            LinkButtonXemGuiLai.Visible = true;
                        }

                        break;
                }
            }
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
                    if (oCD.MA.Contains("TP"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                //decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal LoginDonViID = 0;
                if (DropToaAn.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(DropToaAn.SelectedValue);
                }
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }

        public void LoadGrid()
        {
            pn_thuhoi.Visible = false;
            dgList.Visible = false;
            lbtthongbao.Text = "";
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            if (ddlTrangthaiDongBo.SelectedValue == "0")
            {
                btnGuiDLC.Visible = true;
            }
            else
            {
                btnGuiDLC.Visible = false;
            }

            DongBoDLDCQG_BL objBL = new DongBoDLDCQG_BL();

            DataTable tbl = objBL.GetTHAPaging(txtMaVuAn.Text, DropToaAn.SelectedValue, txtTenVuAn.Text, ddlLoaiQuyetDinh.SelectedValue, txtToidanh.Text, txtBican.Text, txtCCCD.Text, txtSoQuyetDinh.Text, txtTuNgay.Text, txtDenNgay.Text, ddlThamphan.SelectedValue, ddlTrangthaiDongBo.SelectedValue, null, null, pageindex, page_size);
            AHS_TONGHOPHINHPHAT ahs_tonghop = new AHS_TONGHOPHINHPHAT();
            if (tbl != null && tbl.Rows.Count > 0)
            {

                foreach (DataRow row in tbl.Rows)
                {
                    if (row["MAGIAIDOAN"] + "" == "2")
                    {
                        row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_ST((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                    }
                    else
                    {
                        row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                    }
                }

                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                hddTotalPage.Value = all_page.ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.Visible = true;
                dgList.DataSource = tbl;
                dgList.DataBind();
            }
            else
            {

                int count_all = 0;
                int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                hddTotalPage.Value = all_page.ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                // lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
                dgList.Visible = true;
                dgList.DataSource = tbl;
                dgList.DataBind();
            }
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        #endregion

        private string thamSoHinhPhat(DataRow row)
        {
            string soNam = row["TG_NAM"].ToString();
            string soThang = row["TG_THANG"].ToString();
            string soNgay = row["TG_NGAY"].ToString();
            string soTien = row["SH_VALUE"].ToString();
            return string.Format("Số Năm: {0}, Số Tháng: {1},  Số ngày: {2}, Số tiền phạt: {3}", getSo(soNam), getSo(soThang), getSo(soNgay), getSoTien(soTien));
        }

        private string getSo(string so)
        {
            if (string.IsNullOrEmpty(so)) return "0";
            return so;
        }

        private string getSoTien(string soTien)
        {
            if (string.IsNullOrEmpty(soTien)) return "0";
            return Convert.ToDecimal(soTien).ToString("N0");

        }
    }
}
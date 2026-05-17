using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class QuyetdinhVuviec : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const String MA_LOAI_QUYET_DINH = "BPXLHC";
        private const String QD_EX = "53-DS";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadNguoiKyInfo();
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    LoadGrid();
                    txtHieulucTu.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    KiemTraDonXL();
                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);

                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }

            //catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

            if (ddlQuyetdinh.SelectedItem.Text.Contains("53-DS"))
            {
                lbthongbao.Text = "";
            }
            else
            {
                List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISXLHC == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
                XLHC_SOTHAM_BANAN banAn = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
                if (banAn != null)
                {
                    lbthongbao.Text = "Vụ việc đã có bản án. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                XLHC_SOTHAM_QUYETDINH qdKetThuc = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).FirstOrDefault();
                if (qdKetThuc != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định kết thúc sơ thẩm. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<XLHC_SOTHAM_THULY> lstCount = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
                if (lstCount.Count == 0)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                if (lstTP.Count == 0)
                {
                    lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.GQ_TINHTRANG != 3).FirstOrDefault();
                if (kc != null)
                {
                    lbthongbao.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;

                }


                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }


        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal QDID = Convert.ToDecimal(rowView["QUYETDINHID"].ToString());
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }

                DataRowView row = (DataRowView)e.Item.DataItem;
                string ma = row["MA"].ToString();
                decimal donID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);

                // Lấy danh sách bản án của đơn
                var listDon = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == donID).ToList();

                // Nếu có bản án
                if (listDon.Count > 0)
                {
                    if (lblSua != null) lblSua.Visible = false;
                    if (lbtXoa != null) lbtXoa.Visible = false;
                }

                XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == donID && x.SOQDBA == QDID).FirstOrDefault();
                if (kc != null)
                {
                    if (kc.GQ_TINHTRANG == 3)
                    {
                        lblSua.Visible = lbtXoa.Visible = false;
                        return;
                    }
                }
                string toagiaiquyetID = e.Item.Cells[10].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }
        private void LoadCombobox()
        {
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISXLHC == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            LoadQD();
        }

        private void LoadQD()
        {

            // án chuyển đi rồi thì không hiển thị
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal donID = Convert.ToDecimal(current_id);

            List<XLHC_SOTHAM_BANAN> listDon = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == donID).ToList();

            var QD = dt.DM_QD_QUYETDINH
            .Where(x => x.ISXLHC == 1 && x.ISSOTHAM == 1 && x.KET_THUC == 0 && x.HIEULUC == 1 && x.MA == QD_EX)
            .ToList();


            if (listDon.Count > 0)
            {
                ddlQuyetdinh.DataSource = QD;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }
            else
            {
                //lay quyet dinh chua ket thuc

                QD = dt.DM_QD_QUYETDINH
                .Where(x => x.ISXLHC == 1 && x.ISSOTHAM == 1 && x.KET_THUC == 0 && x.HIEULUC == 1)
                .OrderBy(y => y.TEN).ToList();

                ddlQuyetdinh.DataSource = QD;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            LoadLydo();
            LoadHTXX();
        }

        private void LoadQDNew()
        {
            //Test thử mix data trong code
            //decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            DM_QD_QUYETDINH_BL qdBL = new DM_QD_QUYETDINH_BL();
            var result = dt.DM_QD_QUYETDINH.Where(x => x.ISXLHC == 1 && x.ISSOTHAM == 1 && x.KET_THUC == 0).OrderBy(y => y.TEN).ToList().Select(x => new
            {
                x.ID,
                x.MA,
                x.TEN,
                FULLDQ = x.MA + " - " + x.TEN // xử lý được vì đang ở C#
            })
    .ToList();


            ddlQuyetdinh.DataSource = result;
            ddlQuyetdinh.DataTextField = "FULLDQ";
            ddlQuyetdinh.DataValueField = "ID";
            ddlQuyetdinh.DataBind();
            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            LoadLydo();
            LoadHTXX();
        }

        private void LoadHTXX()
        {
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
            {
                pnHinhThucXetXu.Visible = true;
            }
            else
            {
                pnHinhThucXetXu.Visible = false;
            }
            ddlHTXX.SelectedIndex = 0;
        }
        private void LoadLydo()
        {
            if (ddlQuyetdinh.Items.Count > 0)
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();
                if (lst != null && lst.Count > 0)
                {
                    pnLyDo.Visible = true;
                    ddlLydo.DataSource = lst;
                    ddlLydo.DataTextField = "TEN";
                    ddlLydo.DataValueField = "ID";
                    ddlLydo.DataBind();
                    ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }
                else
                {
                    pnLyDo.Visible = false;
                }
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            XLHC_SOTHAM_HDXX oND = dt.XLHC_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.NGAYTAO).FirstOrDefault<XLHC_SOTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                XLHC_DON_THAMPHAN oTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM)
                    .OrderByDescending(x => x.NGAYTAO)
                    .FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                        hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKy.Text = txtChucvu.Text = "";
            }
        }
        private void ResetControls()
        {
            ddlLoaiQD.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            txtHieulucTu.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieulucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            hddid.Value = "0";
            lbtDownload.Visible = false;
        }
        private bool CheckValid()
        {
            if ((ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
                && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }
            if (txtNguoiKy.Text.Trim() == "")
            {
                lbthongbao.Text = "Vụ án chưa phân công thẩm phán giải quyết!";
                return false;
            }
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn quyết định. Hãy chọn lại!";
                return false;
            }

            int lengthSoQD = txtSoQD.Text.Trim().Length;
            if (lengthSoQD == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSoQD > 20)
            {
                lbthongbao.Text = "Số quyết định không quá 20 ký tự!";
                txtSoQD.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa nhập ngày quyết định hoặc không hợp lệ !";
                txtNgayQD.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtHieulucTu.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa nhập hiệu lực từ ngày hoặc không hợp lệ !";
                txtHieulucTu.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtHieulucDenNgay.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa nhập hiệu lực đến ngày hoặc không hợp lệ !";
                txtHieulucDenNgay.Focus();
                return false;
            }
            DateTime tuNgay = DateTime.Parse(txtHieulucTu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime denNgay = DateTime.Parse(txtHieulucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (DateTime.Compare(tuNgay, denNgay) > 0)
            {
                lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                txtHieulucDenNgay.Focus();
                return false;
            }
            //Kiểm tra ngày quyết định
            DateTime dNgayQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayQD > DateTime.Now)
            {
                lbthongbao.Text = "Ngày quyết định không được lớn hơn ngày hiện tại !";
                txtNgayQD.Focus();
                return false;
            }
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
            List<XLHC_SOTHAM_THULY> lstGQD = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DONID).OrderByDescending(y => y.NGAYTHULY).ToList();
            if (lstGQD.Count > 0)
            {
                XLHC_SOTHAM_THULY oDXL = lstGQD[0];
                if (dNgayQD < oDXL.NGAYTHULY)
                {
                    lbthongbao.Text = "Ngày quyết định không được trước ngày thụ lý '" + ((DateTime)oDXL.NGAYTHULY).ToString("dd/MM/yyyy") + "' !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            //----------------------------
            string so = txtSoQD.Text;
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "XLHC", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "XLHC", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    if (CheckID != CurrID)
                    {
                        strMsg = "Số Quyết định " + txtSoQD.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoQD.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoQD.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                XLHC_SOTHAM_QUYETDINH oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new XLHC_SOTHAM_QUYETDINH();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                }
                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(d => d.ID == oND.QUYETDINHID).FirstOrDefault();
                if (objQD == null || objQD.LOAIID == null)
                {
                    lbthongbao.Text = "Quyết định không tồn tại !";
                    return;
                }
                oND.LOAIQDID = objQD.LOAIID;

                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);
                if (pnLyDo.Visible)
                {
                    oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
                }
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                oND.SOQD = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTu.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieulucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;

                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = "";
                        if (chkKySo.Checked)
                        {
                            string[] arr = hddFilePath.Value.Split('/');
                            strFilePath = arr[arr.Length - 1];
                            strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                        }
                        else
                            strFilePath = hddFilePath.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                }
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_SOTHAM_QUYETDINH.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        public void LoadGrid()
        {
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_SOTHAM_QUYETDINH_GETLIST(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            pnHinhThucXetXu.Visible = false;
            ResetControls();
        }
        public void xoa(decimal id)
        {
            XLHC_SOTHAM_QUYETDINH oND = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            {
                lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                return;
            }
            dt.XLHC_SOTHAM_QUYETDINH.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            XLHC_SOTHAM_QUYETDINH oND = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            //if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            LoadQD();
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            LoadLydo();
            LoadHTXX();
            ddlHTXX.SelectedValue = oND.HINHTHUCXETXU.ToString();
            if (oND.LYDOID != null && pnLyDo.Visible) ddlLydo.SelectedValue = oND.LYDOID.ToString();
            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            if (oND.HIEULUCTU != null) txtHieulucTu.Text = ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            if (oND.HIEULUCDEN != null) txtHieulucDenNgay.Text = ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if ((oND.TENFILE + "") != "")
            {
                lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
                    break;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            XLHC_SOTHAM_QUYETDINH oND = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                //ddlLoaiQD.SelectedValue = oT.LOAIID + "";
                txtHieulucTu_TextChanged(sender, e);
            }
            //Load số quyêt định với các loại QD XLHC sau
            if (ID == 62 || ID == 63 || ID == 67 || ID == 68 || ID == 41 || ID == 42 || ID == 45 || ID == 147 || ID == 4 || ID == 61)
            {
                // lấy số mới nhất 
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DateTime ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                String STTNew = oSTBL.GET_SQD_NEW(DonViID, "XLHC", ngayQD, ID).ToString();
                txtSoQD.Text = STTNew;
            }
            LoadLydo();
            LoadHTXX();
        }
        protected void txtHieulucTu_TextChanged(object sender, EventArgs e)
        {
            if (txtHieulucTu.Text != "")
            {
                DateTime dFrom = DateTime.Parse(this.txtHieulucTu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dFrom != DateTime.MinValue)
                {
                    int SoThangTheoLuat = Convert.ToInt32(hddThoiHanThang.Value), SoNgayTheoLuat = Convert.ToInt32(hddThoiHanNgay.Value);
                    dFrom = dFrom.AddMonths(SoThangTheoLuat);
                    dFrom = dFrom.AddDays(SoNgayTheoLuat);
                    txtHieulucDenNgay.Text = dFrom.ToString("dd/MM/yyyy", cul);
                }
            }
        }

        private void KiemTraDonXL()
        {
            // án chuyển đi rồi thì không hiển thị
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal donID = Convert.ToDecimal(current_id);

            List<XLHC_SOTHAM_BANAN> listDon = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == donID).ToList();

            var QD = dt.DM_QD_QUYETDINH
            .Where(x => x.ISXLHC == 1 && x.ISSOTHAM == 1 && x.KET_THUC == 0 && x.HIEULUC == 1 && x.MA == QD_EX)
            .ToList();


            if (listDon.Count > 0)
            {
                ddlQuyetdinh.DataSource = QD;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }
        }
    }
}
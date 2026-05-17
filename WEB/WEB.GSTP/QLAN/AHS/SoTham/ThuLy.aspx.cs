using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using BL.GSTP.QLAN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal magiaidoan = ENUM_GIAIDOANVUAN.SOTHAM;
        private decimal loaian = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);

        public String NgayHoSo;
        public Decimal VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    ddlSothuly.Visible = false;
                    ddlStlPhu.Visible = false;

                    VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

                    lstMsgB.Text = "";
                    if (!IsPostBack)
                    {
                        if (CheckChuaChonTDC())
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Bạn chưa cập nhật tội danh chính của bị can/bị cáo!');", true);
                        LoadDrop();
                        LoadDropNoidung();
                        CheckQuyen();
                        LoadGrid();
                        LoadTHThuyLy(VuAnID);
                        if (rpt.Items.Count == 0)
                        {
                            SetNew_SoThuLy();
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        private void LoadTHThuyLy(decimal vid)
        {
            //Load Truong hop thu lý
            AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == vid).FirstOrDefault();
            if (obj.TRUONGHOPGIAONHAN == 270)
            {   // Phúc tham huy
                ddTruongHopTL.SelectedValue = "236";
                ddTruongHopTL.Enabled = false;
                pnlNoidung.Visible = true;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else if (obj.TRUONGHOPGIAONHAN == 1758)
            {
                //GDT huy
                ddTruongHopTL.SelectedValue = "1777";
                ddTruongHopTL.Enabled = false;
                pnlNoidung.Visible = true;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else
            {
                ddTruongHopTL.Enabled = true;
                pnlNoidung.Visible = false;
            }
        }
        void CheckQuyen()
        {
            int GiaiDoan = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdThemmoi, oPer.CAPNHAT);

            Decimal VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (VuAnID == 0)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
            }

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                GiaiDoan = (int)oT.MAGIAIDOAN;
                NgayHoSo = oT.NGAYBANCAOTRANG + "" == "" ? "" : ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);
            }

            if (GiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM || GiaiDoan == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN + "";
                lstMsgB.Text = "Vụ án đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }

            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID).ToList();
            if (lst == null || lst.Count == 0)
            {
                lstMsgB.Text = "Các bị can trong vụ án chưa được gán tội danh. Đề nghị cập nhật thông tin này !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }
            if (CheckChuaChonTDC())
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }
            //Cho phép thêm thụ lý khi có quyết định điều tra bổ sung, số lần thụ lý không được phép quá số lần điều tra bổ sung
            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && (x.QUYETDINHID == 221 || x.QUYETDINHID == 222)).ToList();
            if (qd.Count == tl.Count)
            {
                Cls_Comon.SetButton(cmdUpdate, true);
                Cls_Comon.SetButton(cmdThemmoi, true);
            }
            else
            {
                //Nếu đã có Bản án hoặc Quyết định gây kết thúc gán theo thụ lý thì không cho nhập
                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                decimal THULYID = tl[0].ID;
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, THULYID);
                if (oDT.Rows.Count > 0)
                {
                    lstMsgB.Text = "Vụ án đã có quyết định kết thúc, không được sửa đổi !";
                }

                AHS_SOTHAM_BANAN ba = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (ba != null && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
                {
                    lstMsgB.Text = "Vụ án đã có bản án, không được sửa đổi !";
                }

                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgB.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                return;
            }
        }
        private decimal SetNew_SoThuLy()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
            if (String.IsNullOrEmpty(txtNgayThuLy.Text))
                txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");

            DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            string sothulymoi = oSTBL.GET_STL_NEW_HS(DonViID, "AHS", CheckThanhNien(), ngaythuly).ToString();

            if (!ddlSothuly.Items.Contains(new ListItem(sothulymoi)))
            {
                ddlSothuly.Items.Add(new ListItem(sothulymoi));
            }

            if (ddlSothuly.Items.Count == 1)
            {
                ddlSothuly.SelectedValue = sothulymoi;
            }
            else
            {
                ddlSothuly.Items.Add(new ListItem(""));
                ddlSothuly.SelectedValue = "";
            }

            ddlStlPhu_AddItems();
            txtSoThuly.Text = sothulymoi;

            return Convert.ToDecimal(sothulymoi);
        }
        private void LoadInfo(decimal ThuLyID)
        {
            lttCanhBao.Text = lstMsgB.Text = "";
            AHS_SOTHAM_THULY obj = dt.AHS_SOTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault<AHS_SOTHAM_THULY>();
            if (obj != null)
            {
                txtNgayThuLy.Text = (DateTime)obj.NGAYTHULY == DateTime.MinValue ? "" : ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);

                txtSoThuly.Text = obj.SOTHULY;

                ddlSothuly.Items.Clear();
                string ddlSothuly_Add = Regex.Match(obj.SOTHULY, @"\d+").Value;
                ddlSothuly.Items.Add(new ListItem(ddlSothuly_Add));
                ddlSothuly.SelectedValue = ddlSothuly_Add;

                ddlStlPhu_AddItems();
                string stlphu = obj.SOTHULY.ToString().Replace(ddlSothuly.SelectedValue, "");

                if (stlphu.Length != 0)
                {
                    if (!ddlStlPhu.Items.Contains(new ListItem(stlphu)))
                    {
                        ddlStlPhu.Items.Add(new ListItem(stlphu));
                    }
                    ddlStlPhu.SelectedValue = stlphu;
                }

                if (obj.THOIHANTUNGAY != null)
                {
                    txtTuNgay.Text = (DateTime)obj.THOIHANTUNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                }

                if (obj.THOIHANDENNGAY != null)
                {
                    txtDenNgay.Text = (DateTime)obj.THOIHANDENNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                }

                ddTruongHopTL.SelectedValue = obj.TRUONGHOPTHULY + "";

                if (ddTruongHopTL.SelectedValue == "236" || ddTruongHopTL.SelectedValue == "1777")//Thụ lý xx lại
                {
                    pnlNoidung.Visible = true;
                    if (obj.NOIDUNGTLXXLAI != null)
                    {
                        ddlNoidung.SelectedValue = obj.NOIDUNGTLXXLAI + "";
                        if (ddlNoidung.SelectedValue == "2244")
                        {
                            pnlGhichu.Visible = true;
                            txtGhichu.Text = obj.GHICHUKHAC;
                        }
                        else
                        {
                            pnlGhichu.Visible = false;
                            txtGhichu.Text = "";
                        }
                    }
                }
                else
                {
                    pnlNoidung.Visible = false;
                    ddlNoidung.SelectedIndex = 0;
                    txtGhichu.Text = "";
                }

                if (ddTruongHopTL.SelectedValue == "233")// Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung
                {
                    pnTTCaoTrang.Visible = true;
                    txtSoBanCaoTrang.Text = obj.SOBANCAOTRANG;
                    txtNgayBanCaoTrang.Text = obj.NGAYBANCAOTRANG + "" == "" ? "" : ((DateTime)obj.NGAYBANCAOTRANG).ToString("dd/MM/yyyy");
                }
                else
                {
                    pnTTCaoTrang.Visible = false;
                    txtSoBanCaoTrang.Text = "";
                    txtNgayBanCaoTrang.Text = "";
                }
                if (obj.UTTPDI == 1)
                    cbUTTP.Checked = true;
                CanhBao_TamGiam_KC_KN();
            }
        }
        void LoadDrop()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TRUONGHOPTHULYAN);

            ddTruongHopTL.Items.Clear();
            //  ddTruongHopTL.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    ddTruongHopTL.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        void LoadDropNoidung()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NOIDUNGTHULYXXL);

            ddlNoidung.Items.Clear();
            ddlNoidung.DataSource = tbl;
            ddlNoidung.DataTextField = "TEN";
            ddlNoidung.DataValueField = "ID";
            ddlNoidung.DataBind();
            ddlNoidung.Items.Insert(0, new ListItem("--------Chọn--------", "0"));
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;
            Save();
            ResetForm();
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        void Save()
        {
            Boolean IsNew = false;
            AHS_SOTHAM_THULY obj = null;
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            DateTime NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal ThuLyID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            decimal ToaID = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            AHS_SOTHAM_THULY_BL objBL = new AHS_SOTHAM_THULY_BL();
            //------------------------------
            if (ThuLyID > 0)
            {
                obj = dt.AHS_SOTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault<AHS_SOTHAM_THULY>();
                IsNew = false;
            }
            else
            {
                obj = new AHS_SOTHAM_THULY();
                IsNew = true;
            }

            obj.VUANID = VuAnId;

            obj.SOTHULY = ddlSothuly.SelectedValue + ddlStlPhu.SelectedValue;
            obj.SOTHULY = txtSoThuly.Text;
            
            obj.NGAYTHULY = NGAYTHULY;
            obj.THOIHANTUNGAY = NGAYTHULY;
            obj.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.Now.AddDays(15) : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            obj.TRUONGHOPTHULY = Convert.ToDecimal(ddTruongHopTL.SelectedValue);

            if (ddTruongHopTL.SelectedValue == "236" || ddTruongHopTL.SelectedValue == "1777")//Thụ lý xx lại
            {
                pnlNoidung.Visible = true;
                if (ddlNoidung.SelectedIndex > 0)
                {
                    obj.NOIDUNGTLXXLAI = Convert.ToDecimal(ddlNoidung.SelectedValue);
                    if (ddlNoidung.SelectedValue == "2244")
                    {
                        pnlGhichu.Visible = true;
                        obj.GHICHUKHAC = txtGhichu.Text.Trim();
                    }
                    else
                    {
                        pnlGhichu.Visible = false;
                        obj.GHICHUKHAC = "";
                    }
                }
                else
                {
                    obj.NOIDUNGTLXXLAI = null;
                    obj.GHICHUKHAC = "";
                }
            }
            else
            {
                pnlNoidung.Visible = false;
                obj.NOIDUNGTLXXLAI = null;
                obj.GHICHUKHAC = "";
            }

            if (cbUTTP.Checked)
                obj.UTTPDI = 1;
            else
                obj.UTTPDI = 0;

            if (ddTruongHopTL.SelectedValue == "233")// Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung
            {
                obj.SOBANCAOTRANG = txtSoBanCaoTrang.Text;
                obj.NGAYBANCAOTRANG = txtNgayBanCaoTrang.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBanCaoTrang.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            }

            STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            if (oQLSTL.update_STPT_QUANLY_SOTHULY(2, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul), Regex.Match(obj.SOTHULY, @"\d+").Value) == false)
            {
                lstMsgB.Text = "Lưu không thành công!";
                return;
            }

            if (IsNew)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                decimal STT = objBL.GETNEWTT(ToaID, NGAYTHULY);
                obj.TT = STT;

                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHS_SOTHAM_THULY.Add(obj);
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            dt.SaveChanges();

            // update giai đoạn vụ án = sotham
            AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnId).FirstOrDefault<AHS_VUAN>();
            if (objAn != null)
            {
                objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                objAn.NGAYSUA = DateTime.Now;
                objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("1", VuAnId, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                //------------
            }
            dt.SaveChanges();
            lstMsgB.Text = "Lưu dữ liệu thành công!";
        }
        private void LoadGrid()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
            DataTable tbl = obj.GetByVuAnID(VuAnID);
            rpt.DataSource = tbl;
            rpt.DataBind();
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                LinkButton lbtXoaSothulyKhongSuDungLai = (LinkButton)e.Item.FindControl("lbtXoaSothulyKhongSuDungLai");
                Cls_Comon.SetLinkButton(lbtXoaSothulyKhongSuDungLai, oPer.XOA);

                lbtXoaSothulyKhongSuDungLai.Visible = false;

                /* Nếu đã có Phân công thẩm phán, Người tiến hành TT, Bản án sơ thẩm thì không cho sửa xóa thụ lý*/
                int CheckBanAnST = (string.IsNullOrEmpty(rowView["CheckBanAnST"] + "")) ? 0 : Convert.ToInt16(rowView["CheckBanAnST"] + "");
                int CheckPhanCongTP = (string.IsNullOrEmpty(rowView["CheckPhanCongTP"] + "")) ? 0 : Convert.ToInt16(rowView["CheckPhanCongTP"] + "");
                int CheckNguoiTienHanhTT = (string.IsNullOrEmpty(rowView["CheckNguoiTienHanhTT"] + "")) ? 0 : Convert.ToInt16(rowView["CheckNguoiTienHanhTT"] + "");
                int CheckQuyetdinhKetthucST = (string.IsNullOrEmpty(rowView["CheckQuyetdinhKetthucST"] + "")) ? 0 : Convert.ToInt16(rowView["CheckQuyetdinhKetthucST"] + "");

                if (CheckBanAnST > 0 || CheckQuyetdinhKetthucST > 0 || CheckPhanCongTP > 0 || CheckNguoiTienHanhTT > 0 /*|| hddIsShowCommand.Value == "False"*/)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                int MaGiaiDoanVuAn = (string.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt32(hddGiaiDoanVuAn.Value);
                if (MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.PHUCTHAM || MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }
                int CheckDelete = (string.IsNullOrEmpty(rowView["CheckDelete"] + "")) ? 0 : Convert.ToInt16(rowView["CheckDelete"] + "");
                if (CheckDelete > 0)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                bool isReadOnly = _chuyenNhanBl.CheckIsReadOnlyThuLyST(Convert.ToDecimal(rowView["ID"].ToString()), VuAnID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (isReadOnly)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }


                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThuLyID = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = ThuLyID + ""; ;
                    LoadInfo(ThuLyID);

                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    if (lblSua.Text == "Sửa")
                    {
                        Cls_Comon.SetButton(cmdUpdate, true);
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdUpdate, false);
                    }

                    break;

                case "Xoa":

                    hddXoa_SelectedIndex.Value = "1";
                    hddThulyID.Value = ThuLyID.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;

                case "XoaSothulyKhongSuDungLai":

                    hddXoa_SelectedIndex.Value = "2";
                    hddThulyID.Value = ThuLyID.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;
            }
        }

        void ResetForm()
        {
            hddID.Value = "0";
            txtDenNgay.Text = "";
            txtTuNgay.Text = txtNgayThuLy.Text = "";

            txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            SetNew_SoThuLy();
            ddlStlPhu_AddItems();

            txtSoBanCaoTrang.Text = txtNgayBanCaoTrang.Text = "";
            lttCanhBao.Text = "";
            ddTruongHopTL.SelectedIndex = 0;
            pnTTCaoTrang.Visible = false;
            pnlNoidung.Visible = false;
            cbUTTP.Checked = false;
            ddlNoidung.SelectedIndex = 0;
        }
        protected void cmdThemmoi_Click(object sender, EventArgs e)
        {
            ResetForm();
            SetNew_SoThuLy();
        }
        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            try
            {
                txtTuNgay.Text = txtNgayThuLy.Text;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]), LoaiToiPhamID = 0;
                DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                SetNew_SoThuLy();
                //try
                //{
                //    ddlSothuly.Items.Clear();

                //    STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
                //    DataTable dtStl = oQLSTL.get_STPT_QUANLY_SOTHULY(2, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgayThuLy.Text);
                //    if (dtStl != null)
                //    {
                //        ddlSothuly.DataSource = dtStl;
                //        ddlSothuly.DataTextField = "SOTHULY";
                //        ddlSothuly.DataValueField = "SOTHULY";
                //        ddlSothuly.DataBind();
                //    }

                //    string check_ngaythulycuoi_trongnam = oQLSTL.get_LATEST_DATE_IN_SOTHULY(2, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgayThuLy.Text);

                //    DateTime check_ngaythulycuoi = DateTime.Parse(check_ngaythulycuoi_trongnam.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //    if (check_ngaythulycuoi <= DateTime.Parse(txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                //    {
                //        SetNew_SoThuLy();
                //    }
                //}
                //catch
                //{
                //    lstMsgB.Text = "Lỗi lấy danh sách Số thụ lý!";
                //}

                AHS_VUAN vuan = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                if (vuan != null)
                    LoaiToiPhamID = vuan.LOAITOIPHAMID + "" == "" ? 0 : (decimal)vuan.LOAITOIPHAMID;

                DM_DATAITEM dmLoaiToiPham = dt.DM_DATAITEM.Where(x => x.ID == LoaiToiPhamID && x.HIEULUC == 1).FirstOrDefault<DM_DATAITEM>();
                if (dmLoaiToiPham != null)
                {
                    if (NgayThuLy != DateTime.MinValue)
                    {
                        txtDenNgay.Enabled = false;
                        switch (dmLoaiToiPham.MA)
                        {
                            case ENUM_AHS_LOAITOIPHAM.IT_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddDays(30)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddDays(45)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.RAT_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddMonths(2)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.DACBIET_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddMonths(3)).ToString("dd/MM/yyyy", cul);
                                break;
                            default:
                                //chưa xac dinh--> cho phep thay doi
                                txtDenNgay.Enabled = true;
                                break;
                        }
                    }
                    else
                    {
                        //chưa xac dinh--> cho phep thay doi
                        txtDenNgay.Enabled = true;
                    }
                }

                CanhBao_TamGiam_KC_KN();
            }
            catch (Exception ex)
            {
                lstMsgB.Text = ex.Message;
            }
        }
        void CanhBao_TamGiam_KC_KN()
        {
            DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            int songaycanhbao = 3;
            AHS_SOTHAM_BIENPHAPNGANCHAN_BL objBL = new AHS_SOTHAM_BIENPHAPNGANCHAN_BL();
            DataTable tbl = objBL.GetAllBiCanBiGiamGiu(VuAnID);
            if (tbl != null)
            {
                String StrDisplay = "";
                String temp = "";
                String canhbao = "";
                DateTime ngaykt;
                foreach (DataRow row in tbl.Rows)
                {
                    canhbao = "";
                    temp = "";
                    if (!String.IsNullOrEmpty(row["NgayKetThuc"] + ""))
                    {
                        ngaykt = Convert.ToDateTime(row["NgayKetThuc"] + "");
                        if (ngaykt != DateTime.MinValue)
                        {
                            temp = " Đến ngày: " + ngaykt.ToString("dd/MM/yyyy", cul);
                            if (ngaykt < NgayThuLy)
                                canhbao = "<span class='canhbao_thuly'>(Quá hạn)</span>";
                            else
                            {
                                if (NgayThuLy.AddDays(songaycanhbao) >= ngaykt)
                                    canhbao = "<span class='canhbao_thuly'>(Sắp hết hạn)</span>";
                            }
                        }
                    }
                    if (canhbao.Length > 0)
                    {
                        StrDisplay += "<li>Bị can: " + row["TenBiCan"].ToString()
                                        + " - " + row["TenBienPhapNganChan"].ToString()
                                                + ". Từ ngày: " + (Convert.ToDateTime(row["NgayBatDau"] + "")).ToString("dd/MM/yyyy", cul)
                                                + temp
                                                + canhbao
                                     + "</li>";
                    }
                }
                lttCanhBao.Text = (StrDisplay.Length == 0) ? "" : ("<div id='canhbao_form'>" + "<ul>" + StrDisplay + "</ul></div>");
            }
        }
        protected void ddTruongHopTL_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddTruongHopTL.SelectedValue == "233")// Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung
            {
                pnTTCaoTrang.Visible = true;
            }
            else
            {
                pnTTCaoTrang.Visible = false;
            }
            if (ddTruongHopTL.SelectedValue == "236" || ddTruongHopTL.SelectedValue == "1777")
            {
                pnlNoidung.Visible = true;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else
            {
                pnlNoidung.Visible = false;
            }
        }
        protected void ddlNoidung_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNoidung.SelectedValue == "2244")// Nội dung khác
            {
                pnlGhichu.Visible = true;
                txtGhichu.Text = "";
            }
            else
            {
                pnlGhichu.Visible = false;
                txtGhichu.Text = "";
            }
        }
        private bool CheckValidate()
        {
            if (ddTruongHopTL.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!";
                ddTruongHopTL.Focus();
                return false;
            }
            else if (ddTruongHopTL.SelectedValue == "233")
            {
                int lenghtSoBanCaoTrang = txtSoBanCaoTrang.Text.Trim().Length;
                if (lenghtSoBanCaoTrang == 0)
                {
                    lstMsgB.Text = "Bạn chưa nhập số bản cáo trạng. Hãy kiểm tra lại!";
                    txtSoBanCaoTrang.Focus();
                    return false;
                }
                else if (lenghtSoBanCaoTrang > 250)
                {
                    lstMsgB.Text = "Số bản cáo trạng không quá 250 ký tự. Hãy kiểm tra lại!";
                    txtSoBanCaoTrang.Focus();
                    return false;
                }
            }
            DateTime NgayThuLy = DateTime.Parse(txtNgayThuLy.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (DateTime.Compare(DateTime.Now, NgayThuLy) < 0)
            {
                lstMsgB.Text = "Ngày thụ lý phải nhỏ hơn ngày hiện tại. Hãy kiểm tra lại!";
                txtNgayThuLy.Focus();
                return false;
            }
            AHS_VUAN vuan = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (vuan != null)
            {
                if (vuan.NGAYXAYRA + "" != "")
                {
                    if (DateTime.Compare(NgayThuLy, (DateTime)vuan.NGAYXAYRA) < 0)
                    {
                        lstMsgB.Text = "Ngày thụ lý phải lớn hơn ngày xảy ra vụ án (" + ((DateTime)vuan.NGAYXAYRA).ToString("dd/MM/yyyy") + "). Hãy kiểm tra lại!";
                        txtNgayThuLy.Focus();
                        return false;
                    }
                }
            }

            //if (ddlSothuly.Text == "")
            //{
            //    lstMsgB.Text = "Chưa chọn số thụ lý";
            //    return false;
            //}
            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lstMsgB.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            if (txtSoThuly.Text == "")
            {
                lstMsgB.Text = "Chưa nhập số thụ lý";
                return false;
            }

            //string sothuly = ddlSothuly.SelectedValue;

            //if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            //{
            //    DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //    AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
            //    Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS", CheckThanhNien(), sothuly, ngaythuly);
            //    if (CheckID > 0)
            //    {
            //        Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            //        String strMsg = "";
            //        String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS", CheckThanhNien(), ngaythuly).ToString();
            //        if (CheckID != CurrThuLyID)
            //        {
            //            strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
            //            ddlSothuly.Items.Add(new ListItem(STTNew));
            //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            //            ddlSothuly.Focus();
            //            return false;
            //        }
            //    }
            //}
            string sothuly = txtSoThuly.Text;

            if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS", CheckThanhNien(), sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS", CheckThanhNien(), ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuly.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuly.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        private decimal CheckThanhNien()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.ISTHANHNIEN == 0)
            {
                return 2;
            }
            else
            {
                AHS_BICANBICAO dtBiCao = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                AHS_NGUOITHAMGIATOTUNG dtTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                if (dtBiCao != null || dtTGTT != null)
                {
                    return 1;
                }
                return 0;
            }

        }

        protected void btnSaveLydoXoa_Insert(object sender, EventArgs e)
        {
            if (hddThulyID.Value == "0")
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }
            decimal ThuLyID = Convert.ToDecimal(hddThulyID.Value + "");
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            AHS_SOTHAM_THULY oND = dt.AHS_SOTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault();

            decimal VuanID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            if (oPer.XOA == false)
            {
                lstMsgB.Text = "Bạn không có quyền xóa!";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgB.Text = Result;
                return;
            }
            
            LICHSU_XOA_SOTHULY oLS = new LICHSU_XOA_SOTHULY();
            if (oLS.insert_LICHSU_XOA_SOTHULY(magiaidoan, ThuLyID, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), Session[ENUM_SESSION.SESSION_USERNAME] + "", ddlLydoXoaSothuly.SelectedItem.ToString(), VuanID) == false)
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }

            if (Convert.ToDecimal(Regex.Match(oND.SOTHULY, @"\d+").Value) == SetNew_SoThuLy())
            {
                hddXoa_SelectedIndex.Value = "0";
            }

            STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            if (oQLSTL.insert_STPT_QUANLY_SOTHULY(magiaidoan, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul),
                                                Regex.Match(oND.SOTHULY, @"\d+").Value, Convert.ToDecimal(ddlLydoXoaSothuly.SelectedValue), ddlLydoXoaSothuly.SelectedItem.ToString(),
                                                Session[ENUM_SESSION.SESSION_USERNAME] + "", Session[ENUM_SESSION.SESSION_USERTEN] + "", Convert.ToDecimal(hddXoa_SelectedIndex.Value + ""), VuanID) == false)
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }

            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            decimal THULYID = tl[0].ID;

            if (oND != null)
            {
                #region Kiểm tra dữ liệu liên quan trước khi xóa
                // Kiểm tra bản án sơ thẩm
                AHS_SOTHAM_BANAN ba = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuanID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_BANAN>();
                if (ba != null)
                {
                    lstMsgB.Text = "Vụ việc đã có bản sơ thẩm. Không được xóa.";
                    return;
                }
                // Kiểm tra quyết định vụ án
                AHS_SOTHAM_QUYETDINH_VUAN qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuanID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_QUYETDINH_VUAN>();
                if (qd != null)
                {
                    lstMsgB.Text = "Vụ việc đã có quyết định vụ án. Không được xóa.";
                    return;
                }
                // Kiểm tra quyết định bị can, bị cáo
                AHS_SOTHAM_QUYETDINH_BICAN qdbc = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VuanID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_QUYETDINH_BICAN>();
                if (qdbc != null)
                {
                    lstMsgB.Text = "Vụ việc đã có quyết định bị can, bị cáo. Không được xóa.";
                    return;
                }
                // Kiểm tra người tiến hành tố tụng
                AHS_SOTHAM_HDXX hdxx = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuanID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_HDXX>();
                if (hdxx != null)
                {
                    lstMsgB.Text = "Vụ việc đã có thông tin người tiến hành tố tụng. Không được xóa.";
                    return;
                }
                // Kiểm tra phân công thẩm phán giải quyết
                AHS_THAMPHANGIAIQUYET gqst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuanID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.THULYID == THULYID).FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
                if (gqst != null)
                {
                    lstMsgB.Text = "Vụ việc đã có thông tin phân công thẩm phán giải quyết. Không được xóa.";
                    return;
                }
                #endregion
            }

            if (oND != null)
            {

                dt.AHS_SOTHAM_THULY.Remove(oND);
                dt.SaveChanges();
                LoadGrid();
            }
            lstMsgB.Text = "Xóa thành công!";

            hddXoa_SelectedIndex.Value = "0";
            hddThulyID.Value = "0";
        }
        protected void ddlStlPhu_AddItems()
        {
            ddlStlPhu.Items.Clear();
            ddlStlPhu.Items.Add(new ListItem(""));
            ddlStlPhu.Items.Add(new ListItem("A"));
            ddlStlPhu.Items.Add(new ListItem("B"));
            ddlStlPhu.Items.Add(new ListItem("C"));
            ddlStlPhu.Items.Add(new ListItem("D"));
            ddlStlPhu.Items.Add(new ListItem("E"));
        }
        protected void ddlLydoXoa()
        {
            string maLydoxoa = "";
            if (hddXoa_SelectedIndex.Value == "1")
            {
                maLydoxoa = "LYDOXOATHULY";
            }
            else if (hddXoa_SelectedIndex.Value == "2")
            {
                maLydoxoa = "LYDOXOASOTHULY";
            }

            ddlLydoXoaSothuly.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(maLydoxoa);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlLydoXoaSothuly.DataSource = tbl;
                ddlLydoXoaSothuly.DataTextField = "TEN";
                ddlLydoXoaSothuly.DataValueField = "ID";
                ddlLydoXoaSothuly.DataBind();

            }
        }

        protected void btnLichsuXoaThuly_Click(object sender, EventArgs e)
        {
            mdLichsuXoaThuly.Show();
            loadGrid_LichsuXoaThuly();
        }
        protected void loadGrid_LichsuXoaThuly()
        {
            dgLichsuXoaThuly.Visible = true;
            decimal vuanid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            List<LICHSU_XOA_SOTHULY> obj = DataExtensions.GetAllWithClause<LICHSU_XOA_SOTHULY>($"LOAIAN = {loaian} AND MAGIAIDOAN = {magiaidoan} AND TOAAN_ID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])} and DONID = {vuanid}");
            if (obj != null && obj.Count > 0)
            {
                dgLichsuXoaThuly.DataSource = obj;
                dgLichsuXoaThuly.DataBind();
            }
        }
        private bool CheckChuaChonTDC()
        {
            var VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var data = (from a in dt.AHS_BICANBICAO
                        join b in dt.AHS_SOTHAM_CAOTRANG_DIEULUAT on a.ID equals b.BICANID
                        select new
                        {
                            a.ID,
                            b.ISMAIN,
                            a.VUANID
                        })
                       .Where(x => x.VUANID == VuAnID)
                       .GroupBy(x => new { x.ID, x.ISMAIN })
                       .ToList();
            var check = data
                .GroupBy(x => x.Key.ID)
                .Any(g => g.All(x => x.Key.ISMAIN == 0));

            return check;
        }
    }
}


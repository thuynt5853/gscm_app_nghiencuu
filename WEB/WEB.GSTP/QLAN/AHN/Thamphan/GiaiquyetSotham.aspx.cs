using BL.GSTP;
using BL.GSTP.AHN;
using BL.GSTP.QLAN;
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
using System.Web.Script.Serialization;
using BL.GSTP.ADS;
using DevExpress.Office.Utils;

namespace WEB.GSTP.QLAN.AHN.Thamphan
{
    public partial class GiaiquyetSotham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadDataThuKy();
                decimal DONID = Convert.ToDecimal(current_id);
                CheckQuyen(DONID);
                LoadGrid();
            }
        }
        private void LoadDataThuKy()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
            // Lay Thu ky và TTV
            DataTable oCBDT = oDMCBBL.DM_CANBO_GetAllThuKy_TTV(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "");
            if (oCBDT != null)
            {
                if (oCBDT.Rows.Count > 0)
                {
                    ddlThuky.DataSource = oCBDT;
                    ddlThuky.DataTextField = "HOTEN";
                    ddlThuky.DataValueField = "ID";
                    ddlThuky.DataBind();
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                    GetDataDefaultThuKy();
                }
                else
                {
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                }
            }
        }
        private void GetDataDefaultThuKy()
        {
            decimal value = decimal.Parse(ddlThamphan.SelectedValue);
            var obj = dt.CAUHINH_THAMPHAN_THUKY.FirstOrDefault(s => s.THAMPHAMID == value);
            if (obj != null)
            {

                ddlThuky.SelectedValue = obj.THUKYID.Value.ToString();

            }
            else
            {
                ddlThuky.SelectedValue = "0";
            }
        }

        protected void myListDropDown_Change(object sender, EventArgs e)
        {

            GetDataDefaultThuKy();
        }

        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            List<AHN_SOTHAM_THULY> lstCount = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            else
            {
                hddNgayThuLy.Value = lstCount[0].NGAYTHULY + "" == "" ? "" : ((DateTime)lstCount[0].NGAYTHULY).ToString("dd/MM/yyyy");
            }

            AHN_SOTHAM_BANAN oBA = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oBA != null)
            {
                lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH, DONID);
            if (oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }

        //void check(decimal ID)
        //{
        //    string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
        //    decimal DONID = Convert.ToDecimal(current_id);

        //    AHN_CHUYEN_NHAN_AN chuyenan  = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == DONID).FirstOrDefault();
        //    List<AHN_SOTHAM_HDXX> NTHTT = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == ID && x.NGAYTAO >= chuyenan.NGAYTAO ).ToList();
        //    if(NTHTT != null && NTHTT.Count > 0)
        //    {
        //        lblSua.Visible = true;
        //        lbtXoa.Visible = true;
        //    }
        //}
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            AHN_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHN_CHUYEN_NHAN_AN_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();

                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                bool isReadOnly = _chuyenNhanBl.CheckIsReadOnlyThamPhanST(Convert.ToDecimal(rowView["ID"].ToString()), DONID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM
                    || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT
                    || hddShowCommand.Value == "False"
                    || isReadOnly
                   /* || (qdCount + bdCount) > 0*/)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;

                }

                //toancau Nhũng bản ghi được thêm sau khi nhận án lại để xét xử tiếp thì được áp dụng tuân theo quy trình xoá ngược ở giải đoạn sau 
                Decimal ID = Convert.ToDecimal(rowView["ID"].ToString());
                AHN_DON_THAMPHAN obj = dt.AHN_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
                if (obj != null)
                {

                    AHN_CHUYEN_NHAN_AN chuyenan = dt.AHN_CHUYEN_NHAN_AN.Where(x => x.VUANID == DONID).OrderByDescending(x => x.ID).FirstOrDefault();
                    if (chuyenan != null)
                    {
                        if (obj.NGAYTAO <= chuyenan.NGAYTAO)
                        {
                            List<AHN_SOTHAM_HDXX> NTHTT = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DONID).ToList();
                            List<AHN_SOTHAM_QUYETDINH> qd = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID).ToList();
                            if ((NTHTT != null && NTHTT.Count > 0) || (qd != null && qd.Count > 0))
                            {
                                lblSua.Visible = false;
                                lbtXoa.Visible = false;

                            }
                        }
                        else
                        {
                            List<AHN_SOTHAM_HDXX> NTHTT = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.NGAYTAO > chuyenan.NGAYTAO).ToList();
                            List<AHN_SOTHAM_QUYETDINH> qd = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.NGAYTAO > chuyenan.NGAYTAO).ToList();
                            if ((NTHTT != null && NTHTT.Count > 0) || (qd != null && qd.Count > 0))
                            {
                                lblSua.Visible = false;
                                lbtXoa.Visible = false;
                            }
                        }

                    }
                    else
                    {
                        decimal DonviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        List<AHN_SOTHAM_HDXX> NTHTT = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == DonviID).ToList();
                        List<AHN_SOTHAM_QUYETDINH> qd = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == DonviID).ToList();
                        if ((NTHTT != null && NTHTT.Count > 0) || (qd != null && qd.Count > 0))
                        {
                            lblSua.Visible = false;
                            lbtXoa.Visible = false;
                        }
                    }
                }


                if (toagiaiquyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;

                }

                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddShowCommand.Value = "False";
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}


                //if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || hddShowCommand.Value == "False")
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //}


            }
        }
        private void LoadCombobox()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            ddlNguoiphancong.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
            //ddlNguoiphancong.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));


            //Load quốc tịch
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtVaiTro = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.VAITROTHAMPHAN);

            ddlVaitro.DataSource = dtVaiTro;
            ddlVaitro.DataTextField = "TEN";
            ddlVaitro.DataValueField = "MA";
            ddlVaitro.DataBind();
            ddlVaitro.SelectedValue = ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM;
            ddlVaitro.Enabled = false;
        }
        private void ResetControls()
        {
            ddlThamphan.SelectedIndex = 0;
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = "";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            if (ddlThamphan.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thẩm phán !";
                return false;
            }

            if (ddlVaitro.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn vai trò thẩm phán !";
                return false;
            }
            if (txtNgayphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày phân công !";
                txtNgayphancong.Focus();
                return false;
            }
            DateTime dNgayPhanCong = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayPhanCong > DateTime.Now)
            {
                lbthongbao.Text = "Ngày phân công không được lớn hơn ngày hiện tại !";
                txtNgayphancong.Focus();
                return false;
            }
            DateTime NgayThuLy = hddNgayThuLy.Value == "" ? DateTime.MinValue : DateTime.Parse(hddNgayThuLy.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayPhanCong < NgayThuLy)
            {
                lbthongbao.Text = "Ngày phân công không được nhỏ hơn ngày thụ lý " + hddNgayThuLy.Value;
                txtNgayphancong.Focus();
                return false;
            }
            if (txtNhanphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày nhận phân công !";
                txtNhanphancong.Focus();
                return false;
            }
            DateTime dNgayNhanPC = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhanPC < dNgayPhanCong)
            {
                lbthongbao.Text = "Ngày nhận phân công không được nhỏ hơn ngày phân công !";
                txtNhanphancong.Focus();
                return false;
            }
            if (dNgayNhanPC > DateTime.Now)
            {
                lbthongbao.Text = "Ngày nhận phân công không được lớn hơn ngày hiện tại !";
                txtNhanphancong.Focus();
                return false;
            }
            if (txtNgayketthuc.Text.Trim() != "")
            {
                DateTime dNgayKetThuc = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKetThuc < dNgayNhanPC)
                {
                    lbthongbao.Text = "Ngày kết thúc không được nhỏ hơn ngày nhận phân công !";
                    txtNgayketthuc.Focus();
                    return false;
                }
            }
            if (ddlNguoiphancong.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn người phân công !";
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "", MaVaiTro = ddlVaitro.SelectedValue;
                decimal DONID = Convert.ToDecimal(current_id), CanBoID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                AHN_DON_THAMPHAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    oND = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DONID && x.CANBOID == CanBoID && x.MAVAITRO == MaVaiTro).FirstOrDefault();
                    if (oND != null)
                    {
                        lbthongbao.Text = "Thẩm phán " + ddlThamphan.SelectedItem.Text + " đã được phân công. Hãy chọn lại!";
                        ddlThamphan.Focus();
                        return;
                    }
                    oND = new AHN_DON_THAMPHAN();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHN_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.CANBOID = CanBoID;
                oND.THUKYID = Convert.ToDecimal(ddlThuky.SelectedValue);
                oND.MAVAITRO = MaVaiTro;
                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);


                DateTime dNgayPhanCong = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYPHANCONG = dNgayPhanCong;

                DateTime dNgayNhanPhanCong = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYNHANPHANCONG = dNgayNhanPhanCong;


                DateTime dNgayKetthuc = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = dNgayKetthuc == DateTime.MinValue ? (DateTime?)null : dNgayKetthuc;

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.AHN_DON_THAMPHAN.Add(oND);
                    dt.SaveChanges();

                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                //Khi them tham phan Giai quyet don thi tu them Thẩm phán chủ tọa phiên tòa
                AHN_SOTHAM_HDXX oTHTT = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHN_SOTHAM_HDXX>();
                decimal toaGiaiQuyet = 0;
                if (oTHTT != null)
                    toaGiaiQuyet = Convert.ToDecimal(oTHTT.TOA_GIAIQUYET_ID);
                if (oTHTT == null || toaGiaiQuyet != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                {
                    oTHTT = new AHN_SOTHAM_HDXX();
                    oTHTT.CANBOID = CanBoID;
                    oTHTT.DONID = DONID;
                    oTHTT.MAVAITRO = ENUM_NGUOITIENHANHTOTUNG.THAMPHAN;
                    oTHTT.NGAYPHANCONG = dNgayPhanCong;
                    oTHTT.NGAYNHANPHANCONG = dNgayNhanPhanCong;
                    oTHTT.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                    oTHTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oTHTT.NGAYTAO = DateTime.Now;
                    oTHTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.AHN_SOTHAM_HDXX.Add(oTHTT);
                    dt.SaveChanges();
                }

                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            AHN_DON_THAMPHAN_BL oBL = new AHN_DON_THAMPHAN_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AHN_DON_THAMPHAN_GETBY(ID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM);

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
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        public void xoa(decimal id)
        {

            AHN_DON_THAMPHAN oND = dt.AHN_DON_THAMPHAN.Where(x => x.ID == id).FirstOrDefault();
            //Luu thong tin Thẩm phán giải quyết Sơ thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 3, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thẩm phán giải quyết Sơ thẩm án Hôn nhân", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc
            //Xoa Thẩm phán giải quyết Sơ thẩm
            dt.AHN_DON_THAMPHAN.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            AHN_DON_THAMPHAN oND = dt.AHN_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (ddlThamphan.Items.FindByValue(oND.CANBOID + "") != null)
                ddlThamphan.SelectedValue = oND.CANBOID + "";
            if (ddlThuky.Items.FindByValue(oND.THUKYID + "") != null)
                ddlThuky.SelectedValue = oND.THUKYID + "";
            else
                ddlThuky.SelectedValue = 0 + "";
            ddlVaitro.SelectedValue = oND.MAVAITRO;
            txtNgayphancong.Text = (oND.NGAYPHANCONG == DateTime.MinValue || oND.NGAYPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNhanphancong.Text = (oND.NGAYNHANPHANCONG == DateTime.MinValue || oND.NGAYNHANPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = (oND.NGAYKETTHUC == DateTime.MinValue || oND.NGAYKETTHUC + "" == "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
            if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID + "") != null)
                ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID + "";
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");

            string[] arr = e.CommandArgument.ToString().Split('#');
            decimal ND_id = Convert.ToDecimal(arr[0]),
                    TPID = Convert.ToDecimal(arr[1]);

            //AHN_SOTHAM_HDXX hdxx = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DonID).FirstOrDefault();
            //AHN_SOTHAM_QUYETDINH qd = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID).FirstOrDefault();

            switch (e.CommandName)
            {
                case "Sua":
                    //if (hdxx != null) { lbthongbao.Text = "Đã có người tiến hành tố tụng, không được sửa !"; return; }
                    //if (qd != null) { lbthongbao.Text = "Đã có quyết định, không được sửa !"; return; }

                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = ND_id + "";
                    break;
                case "Xoa":
                    //if (hdxx != null) { lbthongbao.Text = "Đã có người tiến hành tố tụng, không được xóa !"; return; }
                    //if (qd != null) { lbthongbao.Text = "Đã có quyết định, không được xóa !"; return; }

                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    if (!CheckQDofThamPhan(DonID, TPID))
                    {
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion

        protected void txtNgayphancong_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayketthuc.ClientID);
            }
        }
        protected void txtNhanphancong_TextChanged(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNgayphancong.Text))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayketthuc.ClientID);
            }
        }
        private bool CheckQDofThamPhan(decimal DonID, decimal TPID)
        {
            // kiểm tra các quyết định mà thẩm phán đã ký trong vụ việc (nếu có)
            AHN_SOTHAM_QUYETDINH obj_QD = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.NGUOIKYID == TPID).FirstOrDefault<AHN_SOTHAM_QUYETDINH>();
            if (obj_QD != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký quyết định của vụ việc. Không được xóa!";
                return false;
            }
            return true;
        }
    }
}
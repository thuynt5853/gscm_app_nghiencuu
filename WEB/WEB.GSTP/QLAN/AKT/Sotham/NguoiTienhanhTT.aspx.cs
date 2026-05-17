using BL.GSTP;
using BL.GSTP.AKT;
using BL.GSTP.QLAN;
using BL.GSTP.Danhmuc;
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

namespace WEB.GSTP.QLAN.AKT.Sotham
{
    public partial class NguoiTienhanhTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    ddlTucachTGTT_SelectedIndexChanged(sender, e);
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    
                    hdfHTND.Value = ENUM_NGUOITIENHANHTOTUNG.HTND;
                    hdfThuKy.Value = ENUM_NGUOITIENHANHTOTUNG.THUKY;
                    hdfKSV.Value = ENUM_NGUOITIENHANHTOTUNG.KIEMSOATVIEN;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            
            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<AKT_SOTHAM_THULY> lstCount = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            AKT_DON_THAMPHAN obj = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).OrderByDescending(x => x.NGAYNHANPHANCONG).FirstOrDefault();
            if (obj != null)
            {
                hdfNgayPCTPGQ.Value = obj.NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)obj.NGAYNHANPHANCONG).ToString("dd/MM/yyyy");
            }
            else
            {
                lbthongbao.Text = "Chưa cập nhật thông tin phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            List<AKT_DON_THAMPHAN> lst = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList<AKT_DON_THAMPHAN>();
            if (lst == null || lst.Count == 0)
            {
                lbthongbao.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            AKT_SOTHAM_BANAN oBA = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
            if (oBA != null)
            {
                lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI, ID);
            if (oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
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

               
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                int CheckBanAnST = (string.IsNullOrEmpty(rowView["CheckBanAnST"] + "")) ? 0 : Convert.ToInt16(rowView["CheckBanAnST"] + "");
                if (CheckBanAnST > 0)
                    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                //toancau Nhũng bản ghi được thêm sau khi nhận án lại để xét xử tiếp thì được áp dụng tuân theo quy trình xoá ngược ở giải đoạn sau 
                Decimal ID = Convert.ToDecimal(rowView["ID"].ToString());
                AKT_SOTHAM_HDXX obj = dt.AKT_SOTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
                if (obj != null)
                {

                    AKT_CHUYEN_NHAN_AN chuyenan = dt.AKT_CHUYEN_NHAN_AN.Where(x => x.VUANID == DONID).OrderByDescending(x => x.ID).FirstOrDefault();
                    if (chuyenan != null)
                    {
                        if (obj.NGAYTAO <= chuyenan.NGAYTAO)
                        {
                            List<AKT_SOTHAM_QUYETDINH> qd = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID).ToList();
                            if ((qd != null && qd.Count > 0))
                            {
                                lblSua.Visible = false;
                                lbtXoa.Visible = false;

                            }
                        }
                        else
                        {
                            List<AKT_SOTHAM_QUYETDINH> qd = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.NGAYTAO > chuyenan.NGAYTAO).ToList();
                            if ((qd != null && qd.Count > 0))
                            {
                                lblSua.Visible = false;
                                lbtXoa.Visible = false;
                            }
                        }

                    }
                    else
                    {
                        decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        List<AKT_SOTHAM_QUYETDINH> qd = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == Donvi_ID).ToList();
                        if ((qd != null && qd.Count > 0))
                        {
                            lblSua.Visible = false;
                            lbtXoa.Visible = false;
                        }
                    }
                }
                //xử lý phân quyền
                string toagiaiquyetID = e.Item.Cells[9].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

                //AKT_SOTHAM_QUYETDINH qd = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID).FirstOrDefault();
                //if (qd != null)
                //{
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}                             


                //Nếu mà là án đã kết thúc ẩn nút lưu 



                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc == true)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
            }
        }
        private void LoadCombobox()
        {
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_NGUOITIENHANHTOTUNG.THAMPHAN));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký", ENUM_NGUOITIENHANHTOTUNG.THUKY));
            ddlTucachTGTT.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                    DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            // Nếu đã có quyết định đưa vụ án ra xét xử thì mặc định selected thẩm phán được phân công giải quyết
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                AKT_SOTHAM_QUYETDINH qd = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.LOAIQDID == loaiQD.ID).FirstOrDefault<AKT_SOTHAM_QUYETDINH>();
                if (qd != null)
                {
                    AKT_DON_THAMPHAN tpgq = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").OrderByDescending(x => x.NGAYTAO).FirstOrDefault<AKT_DON_THAMPHAN>();
                    if (tpgq != null)
                    {
                        try { ddlThamphan.SelectedValue = tpgq.CANBOID + ""; } catch { }
                    }
                }
            }
            //
            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataSource = oCBDT;
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();

            ddlHTND_NguoiPC.DataSource = oCBDT;
            ddlHTND_NguoiPC.DataTextField = "MA_TEN";
            ddlHTND_NguoiPC.DataValueField = "ID";
            ddlHTND_NguoiPC.DataBind();

            ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
            ddlKSV_Nguoi.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void ResetControls()
        {
            ddlThamphan.SelectedIndex = 0;
            ddlNguoiphancong.SelectedIndex = 0;
            ddlHTND_Thuky.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            ddlKSV_Nguoi.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = "";
            lbthongbao.Text = "";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            string tucach = ddlTucachTGTT.SelectedValue;
            switch (tucach)
            {
                case ENUM_CHUCDANH.CHUCDANH_HTND:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Hội thẩm nhân dân !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKY:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_CHUCDANH.CHUCDANH_KSV:
                    if (ddlKSV_Nguoi.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Kiểm sát viên !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlKSV_Nguoi.ClientID);
                        return false;
                    }
                    break;
                default:
                    if (ddlThamphan.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thẩm phán !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
                        return false;
                    }
                    break;
            }
            if (txtNgayphancong.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày phân công theo định dạng (ngày/tháng/năm).";
                txtNgayphancong.Focus();
                return false;
            }
            if (txtNhanphancong.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNhanphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận phân công theo định dạng (ngày/tháng/năm).";
                txtNhanphancong.Focus();
                return false;
            }

            if (txtNgayketthuc.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayketthuc.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày kết thúc theo định dạng (ngày/tháng/năm).";
                txtNgayketthuc.Focus();
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                string tucach = ddlTucachTGTT.SelectedValue, TenChucDanh = "", TenCanBo = "";
                AKT_SOTHAM_HDXX oND;

                // Lấy count thụ lý và count chủ tọa để cho nhập thêm thẩm phán chủ tọa
                List<AKT_DON_THAMPHAN> countTPGQ = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                List<AKT_SOTHAM_HDXX> countChuToa = dt.AKT_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN)
                    {
                        // Kiểm tra vụ án đã có thẩm phán chủ tọa phiên tòa chưa
                        // Nếu có thì không được phép thêm thẩm phán chủ tọa phiên tòa
                        oND = dt.AKT_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AKT_SOTHAM_HDXX>();
                        if (oND != null && countTPGQ.Count == countChuToa.Count)
                        {
                            lbthongbao.Text = "Vụ án đã có thẩm phán chủ tọa phiên tòa. Không được thêm mới!";
                            ddlThamphan.Focus();
                            return;
                        }
                    }
                    oND = new AKT_SOTHAM_HDXX();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AKT_SOTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.MAVAITRO = ddlTucachTGTT.SelectedValue;
                if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
                {
                    if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
                        TenChucDanh = "Hội thẩm nhân dân";
                    else
                        TenChucDanh = "Thư ký";
                    TenCanBo = (ddlHTND_Thuky.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlHTND_Thuky.SelectedValue);
                    oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlHTND_NguoiPC.SelectedValue);
                    oND.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //oND.DUKHUYET = Convert.ToDecimal(rdbDuKhuyet.SelectedValue);
                }
                else if (tucach== ENUM_CHUCDANH.CHUCDANH_KSV)
                {
                    TenChucDanh = "Kiểm sát viên";
                    TenCanBo = (ddlKSV_Nguoi.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlKSV_Nguoi.SelectedValue);
                }
                else //THAMPHAN, THAMPHANHDXX và THAMPHANDUKHUYET
                {
                    TenChucDanh = "Thẩm phán";
                    TenCanBo = (ddlThamphan.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                    oND.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }

                oND.NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    AKT_SOTHAM_HDXX CheckCanBo = dt.AKT_SOTHAM_HDXX.Where(x => x.DONID == DONID && x.CANBOID == oND.CANBOID).FirstOrDefault();
                    if (CheckCanBo != null && countTPGQ.Count == countChuToa.Count)
                    {
                        lbthongbao.Text = TenChucDanh + " " + TenCanBo + " đã được phân công. Hãy chọn lại!";
                        return;
                    }
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_SOTHAM_HDXX.Add(oND);
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
            AKT_SOTHAM_BL oBL = new AKT_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AKT_SOTHAM_HDXX_GETLIST(ID);

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
            ResetControls();
        }
        public void xoa(decimal id)
        {
            AKT_SOTHAM_HDXX oND = dt.AKT_SOTHAM_HDXX.Where(x => x.ID == id).FirstOrDefault();
            dt.AKT_SOTHAM_HDXX.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            AKT_SOTHAM_HDXX oND = dt.AKT_SOTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            ddlTucachTGTT.SelectedValue = oND.MAVAITRO.ToString();
            string tucach = oND.MAVAITRO.ToString();
            ddlTucachTGTT_SelectedIndexChanged(new object(), new EventArgs());
            if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {
                if (oND.CANBOID != null)
                    if (ddlHTND_Thuky.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlHTND_Thuky.SelectedValue = oND.CANBOID.ToString();
                if (oND.NGUOIPHANCONGID != null)
                    if (ddlHTND_NguoiPC.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlHTND_NguoiPC.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                
                txtNgayphancong.Text = oND.NGAYPHANCONG + "" == "" ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = oND.NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = false;
                pnHTND.Visible = true;// pnDuKhuyet.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
            }
             else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                if (oND.CANBOID != null)
                    if (ddlKSV_Nguoi.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlKSV_Nguoi.SelectedValue = oND.CANBOID.ToString();
                pnThamphan.Visible = false;
                pnHTND.Visible = false; //pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
            }
            else
            {
                if (oND.CANBOID != null)
                    if (ddlThamphan.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlThamphan.SelectedValue = oND.CANBOID.ToString();
                if (oND.NGUOIPHANCONGID != null)
                    if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                txtNgayphancong.Text = oND.NGAYPHANCONG + "" == "" ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = oND.NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false;// pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
            }
            if (oND.NGAYKETTHUC != null) txtNgayketthuc.Text = ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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


        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tucach = ddlTucachTGTT.SelectedValue;
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;

                lblHTND.Text = "Thư ký phiên tòa";

                ddlHTND_Thuky.Items.Clear();
                tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
                ddlHTND_Thuky.DataSource = tbl;
                ddlHTND_Thuky.DataTextField = "MA_TEN";
                ddlHTND_Thuky.DataValueField = "ID";
                ddlHTND_Thuky.DataBind();
                ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
                Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                //pnDuKhuyet.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
                lblHTND.Text = "Tên Hội thẩm nhân dân";
                LoadDrop_CanBoVKS(ddlHTND_Thuky);
                Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                pnThamphan.Visible = pnHTND.Visible = false; //pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
                LoadDrop_CanBoVKS(ddlKSV_Nguoi);
                Cls_Comon.SetFocus(this, this.GetType(), ddlKSV_Nguoi.ClientID);
            }
            else
            {
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false; //pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
            }
        }
        void LoadDrop_CanBoVKS(DropDownList drop)
        {
            String ma_loai_chucdanh = ddlTucachTGTT.SelectedValue;
            Decimal CurrDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBOVKS_BL objBL = new DM_CANBOVKS_BL();
            DataTable tbl = objBL.DM_CANBOVKS_GETBYDONVI_LOAI(CurrDonViID, ma_loai_chucdanh);
            drop.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
             
                    drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else
                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        //protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string tucach = ddlTucachTGTT.SelectedValue;
        //    if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
        //    {
        //        pnThamphan.Visible = false;
        //        pnHTND.Visible = true;
        //        //pnDuKhuyet.Visible = true;
        //        pnKSV.Visible = false;
        //        pnPhancong.Visible = true;
        //        DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
        //        DataTable oCBDT = null;
        //        ddlHTND_Thuky.DataSource = null;
        //        ddlHTND_Thuky.DataBind();
        //        if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND) 
        //        {
        //            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_HTND);
        //            lblHTND.Text = "Tên Hội thẩm nhân dân";
        //        }
        //        else
        //        {
        //            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
        //            lblHTND.Text = "Thư ký phiên tòa";
        //        }
        //        ddlHTND_Thuky.DataSource = oCBDT;
        //        ddlHTND_Thuky.DataTextField = "MA_TEN";
        //        ddlHTND_Thuky.DataValueField = "ID";
        //        ddlHTND_Thuky.DataBind();
        //        ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
        //    }
        //     else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
        //    {
        //        pnThamphan.Visible = pnHTND.Visible = false; // pnDuKhuyet.Visible = false;
        //        pnKSV.Visible = true;
        //        pnPhancong.Visible = false;
        //    }
        //    else
        //    {
        //        pnThamphan.Visible = true;
        //        pnHTND.Visible = pnKSV.Visible = false;//pnDuKhuyet.Visible =false;
        //        pnPhancong.Visible = true;
        //    }
        //}
    }
}
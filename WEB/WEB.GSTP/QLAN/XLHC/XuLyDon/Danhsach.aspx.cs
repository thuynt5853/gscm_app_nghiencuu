using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.XuLyDon
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {

                    txtNgayGQ.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    LoadDropBienPhapGQ();
                    pnCDTN.Visible = pnCDNN.Visible = pnTraDon.Visible = false;
                    decimal DONID = Session[ENUM_LOAIAN.BPXLHC] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
                    CheckQuyen(DONID);
                    LoadGrid_XuLyDon();



                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbtthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdThemmoi, false);
                        Cls_Comon.SetButton(cmdCapNhat, false);
                        hddShowCommand.Value = "False";
                    }
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }

        }
        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
            Cls_Comon.SetButton(cmdCapNhat, oPer.CAPNHAT);

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbtthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
            
            List<XLHC_DON_THAMPHAN> lstCount = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).ToList();
            if (lstCount.Count == 0)
            {
                lbtthongbao.Text = "Chưa phân công thẩm phán giải quyết đơn !";
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<XLHC_SOTHAM_THULY> lstTL = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstTL.Count > 0)
            {
                lbtthongbao.Text = "Đã thụ lý vụ việc không được sửa đổi !";
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            
            // string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg);
            
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg);
            
            if (Result != "")
            {
                lbtthongbao.Text = Result;
                Cls_Comon.SetButton(cmdThemmoi, false);
                Cls_Comon.SetButton(cmdCapNhat, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        void LoadDropBienPhapGQ()
        {
            dropBienPhapGQ.Items.Clear();
            //dropBienPhapGQ.Items.Add(new ListItem("-------- Chọn --------",""));
            //dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn trong Hệ thống Tòa án", ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh));
            //dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn ngoài ngành", ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh));

            dropBienPhapGQ.Items.Add(new ListItem("Bổ sung chứng cứ", ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon));
            dropBienPhapGQ.Items.Add(new ListItem("Trả lại hồ sơ", ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon));
            dropBienPhapGQ.Items.Add(new ListItem("Thụ lý hồ sơ", ENUM_ADS_BIENPHAPGQ.ADS_ThuLy));
            dropBienPhapGQ.SelectedValue = ENUM_ADS_BIENPHAPGQ.ADS_ThuLy;

            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Danh mục lý do tra đơn
            ddlLyTradon.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOTRADON);
            ddlLyTradon.DataTextField = "TEN";
            ddlLyTradon.DataValueField = "ID";
            ddlLyTradon.DataBind();
        }

        private void LoadGrid_XuLyDon()
        {
            XLHC_DON_XULY_BL oBL = new XLHC_DON_XULY_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable oDT = oBL.GetByDonIDV2(DONID, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                DataRow row_last = oDT.Rows[0];
                //LoadInfo_XuLyDon(Convert.ToDecimal(row_last["ID"] + ""));

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {

                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            rpt.DataSource = oDT;
            rpt.DataBind();
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    hddCurrID.Value = CurrID.ToString();
                    LoadInfo_XuLyDon(CurrID);
                    break;
                case "Xoa":
                    if (oPer.XOA == false || cmdCapNhat.Enabled == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    XLHC_DON_XULY oT = dt.XLHC_DON_XULY.Where(x => x.ID == CurrID).FirstOrDefault();
                    if ((oT.CDTN_TOAANID + "") == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                    {
                        lbtthongbao.Text = "Bạn không thể xóa nội dung tòa án khác cập nhật!";
                        return;
                    }
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg);
                    if (Result != "")
                    {
                        lbtthongbao.Text = Result;
                        return;
                    }
                    dt.XLHC_DON_XULY.Remove(oT);
                    dt.SaveChanges();

                    hddPageIndex.Value = "1";
                    LoadGrid_XuLyDon();
                    break;
            }
        }

        void LoadInfo_XuLyDon(Decimal CurrID)
        {
            XLHC_DON_XULY obj = dt.XLHC_DON_XULY.Where(x => x.ID == CurrID).Single<XLHC_DON_XULY>();
            if (obj != null)
            {
                if ((obj.CDTN_TOAANID + "") == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                {
                    lbtthongbao.Text = "Bạn không thể sửa nội dung của tòa án khác cập nhật!";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                }
                txtNgayGQ.Text = (((DateTime)obj.NGAYGQ_YC) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYGQ_YC).ToString("dd/MM/yyyy", cul);
                txtLyDo.Text = obj.LYDO;

                dropBienPhapGQ.SelectedValue = obj.LOAIGIAIQUYET + "";
                string bienphap = dropBienPhapGQ.SelectedValue;
                lblNgayGQ.Text = "Ngày GQ/YC";
                lblLydo.Text = "Lý do";
                switch (bienphap)
                {
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                        pnCDNN.Visible = true;
                        pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        txtCDNN_NgayChuyen.Text = (((DateTime)obj.CDNN_NGAYCHUYEN) == DateTime.MinValue) ? "" : ((DateTime)obj.CDNN_NGAYCHUYEN).ToString("dd/MM/yyyy", cul);
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                        // lblNgayGQ.Text = "Ngày chuyển";
                        pnCDTN.Visible = true;
                        pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                        pnTraDon.Visible = true;
                        pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                        lblLydo.Text = "Ghi chú";
                        txtTradon_Ngay.Text = (((DateTime)obj.TRADON_NGAYTRA) == DateTime.MinValue) ? "" : ((DateTime)obj.TRADON_NGAYTRA).ToString("dd/MM/yyyy", cul);
                        if (obj.TRADON_LYDOID != null)
                            ddlLyTradon.SelectedValue = obj.TRADON_LYDOID.ToString();
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                        pnYCBS.Visible = true;
                        pnTraDon.Visible = false;
                        pnCDTN.Visible = pnCDNN.Visible = false;
                        txtNgayYCBS.Text = (((DateTime)obj.YCBS_NGAYYEUCAU) == DateTime.MinValue) ? "" : ((DateTime)obj.YCBS_NGAYYEUCAU).ToString("dd/MM/yyyy", cul);
                        txtYCBS.Text = obj.YCBS_NOIDUNG + "";
                        break;
                    default:

                        pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;

                        break;
                }

                if (obj.CDTN_TOAANID > 0)
                {
                    hddToaAn.Value = obj.CDTN_TOAANID.ToString();
                    txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == obj.CDTN_TOAANID).Single<DM_TOAAN>().MA_TEN;
                }
                if (obj.TRADON_CANCUID > 0)
                {


                }


                txtCDNN_TenCoQuan.Text = obj.CDNN_TENCQ + "";

            }
        }


        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid_XuLyDon();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid_XuLyDon();
        }

        #endregion
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        void Resetcontrol()
        {
            txtCDNN_TenCoQuan.Text = txtCDNN_NgayChuyen.Text = txtLyDo.Text = txtNgayGQ.Text = txtToaAn.Text = "";

            hddToaAn.Value = "0"; lbtthongbao.Text = "";
            hddCurrID.Value = "0";
            Cls_Comon.SetButton(cmdCapNhat, true);
        }

        protected void ddlBienPhapGQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            //LoadCombobox();
            lblNgayGQ.Text = "Ngày GQ/YC";
            lblLydo.Text = "Lý do";
            string bienphap = dropBienPhapGQ.SelectedValue;
            switch (bienphap)
            {
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                    pnCDNN.Visible = true;
                    pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                    // lblNgayGQ.Text = "Ngày chuyển";
                    pnCDTN.Visible = true;
                    pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                    pnTraDon.Visible = true;
                    pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                    lblLydo.Text = "Ghi chú";
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                    pnYCBS.Visible = true;
                    pnTraDon.Visible = false;
                    pnCDTN.Visible = pnCDNN.Visible = false;
                    break;
                default:
                    pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                    break;
            }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
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
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Xem";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                Literal lttNoiTiepNhan = (Literal)e.Item.FindControl("lttNoiTiepNhan");
                String bienphap = rowView["LoaiGiaiQuyet"] + "";
                switch (bienphap)
                {
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                        lttNoiTiepNhan.Text = rowView["Ten"] + "";
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                        lttNoiTiepNhan.Text = rowView["CDNN_TenCQ"] + "";
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                        lttNoiTiepNhan.Text = rowView["TraDon_CanCuID"] + "";
                        break;
                    default:
                        lttNoiTiepNhan.Text = "";
                        break;
                }
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

            }
        }

        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (txtNgayGQ.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập ngày Ngày GQ/YC";
                txtNgayGQ.Focus();
                return;
            }
            DateTime dNgayGQ = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayGQ > DateTime.Now)
            {
                lbtthongbao.Text = "Ngày GQ/YC không được lớn hơn ngày hiện tại !";
                txtNgayGQ.Focus();
                return;
            }
            if (dNgayGQ.AddDays(1) < oDon.NGAYNHANDON)
            {
                lbtthongbao.Text = "Ngày GQ/YC không được trước ngày nhận đơn '" + ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy") + "' !";
                txtNgayGQ.Focus();
                return;
            }
            int DonXyLyID = 0;
            XLHC_DON_XULY obj = new XLHC_DON_XULY();


            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            {
                DonXyLyID = Convert.ToInt32(hddCurrID.Value);
                obj = dt.XLHC_DON_XULY.Where(x => x.ID == DonXyLyID).FirstOrDefault();
                if (obj != null)
                {
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                else obj = new XLHC_DON_XULY();
            }
            else
            {
                if (dt.XLHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 5).ToList().Count > 0)
                {
                    lbtthongbao.Text = "Đơn đã được thụ lý, không được phép thêm mới !";
                    return;
                }
                if (dt.XLHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 3).ToList().Count > 0)
                {
                    lbtthongbao.Text = "Đơn đã trả lại, không được phép thêm mới !";
                    return;
                }
                obj = new XLHC_DON_XULY();

            }
            obj.LYDO = txtLyDo.Text.Trim();
            obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            obj.DONID = DONID;

            string bienphap = dropBienPhapGQ.SelectedValue;
            obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
            switch (bienphap)
            {
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                    obj.CDTN_TOAANID = hddToaAn.Value == "" ? 0 : Convert.ToDecimal(hddToaAn.Value);
                    //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.CDTN_NGAYCHUYEN = DateTime.Now;
                    obj.TRADON_CANCUID = 0;
                    obj.CDNN_TENCQ = "";
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                    obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Text.Trim();
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.TRADON_CANCUID = 0;
                    obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDNN_NgayChuyen.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                    // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTradon_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon.SelectedValue);
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.YCBS_NOIDUNG = txtYCBS.Text;
                    break;
                default://Thụ lý
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    obj.TRADON_LYDOID = 0;
                    obj.TRADON_NGAYTRA = null;
                    //Cập nhật án phí
                    break;
            }

            if (DonXyLyID == 0)
            {
                obj.NGAYTAO = obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.XLHC_DON_XULY.Add(obj);
            }
            dt.SaveChanges();
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh)
            {
                //obj.CDTN_TOAANID
                //  XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                oDon.TOAANID = obj.CDTN_TOAANID;
                oDon.LOAIDON = 2;
                dt.SaveChanges();
                //Hủy session
                //decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                //if (oNSD != null)
                //{
                //    oNSD.IDBPXLHC = 0;
                //    dt.SaveChanges();
                //    Session[ENUM_LOAIAN.BPXLHC] = 0;
                //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgXLDON", "Hoàn thành chuyển đơn đến tòa án khác, bạn hãy chọn đơn khác để xử lý tiếp !", Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                //}
            }
            else if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_ThuLy)
            { }
            else
            {
                //Hủy session
                //decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                //if (oNSD != null)
                //{
                //    oNSD.IDBPXLHC= 0;
                //    dt.SaveChanges();
                //    Session[ENUM_LOAIAN.BPXLHC] = 0;
                //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgXLDON", "Hoàn thành giải quyết đơn, bạn hãy chọn đơn khác để xử lý tiếp !", Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                //}
            }
            //-------------------------------------
            hddPageIndex.Value = "1";
            LoadGrid_XuLyDon();
            Resetcontrol();
            lbtthongbao.Text = "Lưu thành công!";
        }
    }
}
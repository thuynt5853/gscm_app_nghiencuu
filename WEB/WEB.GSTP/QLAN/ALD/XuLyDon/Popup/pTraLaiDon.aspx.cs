using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.UI;
using System.IO;
using BL.GSTP.BANGSETGET;
using BL.GSTP.ALD;

namespace WEB.GSTP.QLAN.ALD.XuLyDon.Popup
{
    public partial class pTraLaiDon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "", bienphap = dropBienPhapGQ.SelectedValue;
                decimal DONID = Convert.ToDecimal(current_id);
                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                hddNgayNhanDon.Value = oDon.NGAYNHANDON + "" == "" ? "" : ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy");
                try
                {
                    txtNgayGQ.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    LoadDropBienPhapGQ(false);
                    //pnCDTN.Visible = pnCDNN.Visible = pnTraDon.Visible = false;
                    //pnThongbao.Visible = false;

                    // mặc định là trả lại đơn nếu trong yêu cầu bổ sung có tồn tại thụ lý
                    decimal xuLyID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
                    ADS_DON_XULY_BL aDXL = new ADS_DON_XULY_BL();
                    DataTable obj = aDXL.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), xuLyID, 1, 20);
                    foreach (DataRow data in obj.Rows)
                    {
                        if (data["LOAIGIAIQUYET"] + "" == ENUM_ADS_BIENPHAPGQ.ADS_ThuLy)
                        {
                            dropBienPhapGQ.SelectedValue = ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon;
                            dropBienPhapGQ.Enabled = false;

                            pnTraDon.Visible = pnBoSung.Visible = true;
                            pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                            lblLydo.Text = "Ghi chú";
                            pnThongbao.Visible = true;
                            break;
                        }
                    }

                    ALD_DON_XULY donXL = dt.ALD_DON_XULY.Where(x => x.ID == xuLyID).FirstOrDefault();
                    if (donXL.LOAIGIAIQUYET + "" == ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon)
                    {
                        Cls_Comon.SetButton(cmdCapNhat, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdCapNhat, true);
                        Cls_Comon.SetButton(cmdLammoi, true);
                    }

                    LoadDSTL();
                }
                catch (Exception ex) { lbtthongbao.Text = ex.Message; }
            }
        }
        void SetNewSoTB()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ALD_DON_BL oSTBL = new ALD_DON_BL();
            //Số Thông báo mới
            DateTime ngayTB;
            if (!String.IsNullOrEmpty(txtNgaythongbao.Text))
                ngayTB = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayTB = DateTime.Now;

            String STTNew = oSTBL.GET_STB_XLDon_NEW_V2(DonViID, "ALD", ngayTB).ToString();
            txtSothongbao.Text = STTNew;

        }
        void LoadDropBienPhapGQ(bool isThuly)
        {
            dropBienPhapGQ.Items.Clear();
            dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn trong Hệ thống Tòa án", ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh));
            //dropBienPhapGQ.Items.Add(new ListItem("Chuyển đơn ngoài ngành", ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh));
            if (!isThuly)
            {
                dropBienPhapGQ.Items.Add(new ListItem("Trả lại đơn", ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon));
                dropBienPhapGQ.Items.Add(new ListItem("Yêu cầu bổ sung đơn", ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon));
            }
            dropBienPhapGQ.Items.Add(new ListItem("Thụ lý vụ việc", ENUM_ADS_BIENPHAPGQ.ADS_ThuLy));
            
            dropBienPhapGQ.Items.Add(new ListItem("Đơn trùng", ENUM_ADS_BIENPHAPGQ.ADS_DonTrung));

            dropBienPhapGQ.SelectedValue = ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon;
            dropBienPhapGQ.Enabled = false;

            pnTraDon.Visible = pnBoSung.Visible = true;
            pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
            lblLydo.Text = "Ghi chú";
            pnThongbao.Visible = true;

            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Danh mục lý do tra đơn
            ddlLyTradon.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOTRADON);
            ddlLyTradon.DataTextField = "TEN";
            ddlLyTradon.DataValueField = "ID";
            ddlLyTradon.DataBind();
        }
        private bool CheckValid(decimal DONID)
        {
            if (txtNgayGQ.Text == "")
            {
                lbtthongbao.Text = "Bạn chưa nhập Ngày GQ/YC !";
                txtNgayGQ.Focus();
                return false;
            }
            if (!Cls_Comon.IsValidDate(txtNgayGQ.Text))
            {
                lbtthongbao.Text = "Bạn phải nhập ngày GQ/YC theo định dạng (dd/MM/yyyy) !";
                txtNgayGQ.Focus();
                return false;
            }
            DateTime dNgayGQ = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayGQ > DateTime.Now)
            {
                lbtthongbao.Text = "Ngày GQ/YC không được lớn hơn ngày hiện tại !";
                txtNgayGQ.Focus();
                return false;
            }
            if (hddNgayNhanDon.Value != "")
            {
                DateTime NgayNhanDon = DateTime.Parse(hddNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayGQ < NgayNhanDon)
                {
                    lbtthongbao.Text = "Ngày GQ/YC không được nhỏ hơn ngày nhận đơn " + NgayNhanDon.ToString("dd/MM/yyyy") + " !";
                    txtNgayGQ.Focus();
                    return false;
                }
            }
            string bienphap = dropBienPhapGQ.SelectedValue;
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh)
            {
                if (hddToaAn.Value == "0")
                {
                    lbtthongbao.Text = "Bạn chưa chọn tòa án nhận !";
                    txtToaAn.Focus();
                    return false;
                }
            }
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh)
            {
                if (txtCDNN_TenCoQuan.Text == "")
                {
                    lbtthongbao.Text = "Bạn chưa nhập CQ/TC nhận đơn !";
                    txtCDNN_TenCoQuan.Focus();
                    return false;
                }
                if (txtCDNN_NgayChuyen.Text != "")
                {
                    if (!Cls_Comon.IsValidDate(txtCDNN_NgayChuyen.Text))
                    {
                        lbtthongbao.Text = "Bạn phải nhập ngày chuyển theo định dạng (dd/MM/yyyy) !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                    DateTime NgayChuyen = DateTime.Parse(txtCDNN_NgayChuyen.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayChuyen < dNgayGQ)
                    {
                        lbtthongbao.Text = "Ngày chuyển không được nhỏ hơn ngày GQ/YC !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                    if (NgayChuyen > DateTime.Now)
                    {
                        lbtthongbao.Text = "Ngày chuyển không được lớn hơn ngày hiện tại !";
                        txtCDNN_NgayChuyen.Focus();
                        return false;
                    }
                }
            }
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon)
            {
                if (txtTradon_Ngay.Text != "")
                {
                    if (!Cls_Comon.IsValidDate(txtTradon_Ngay.Text))
                    {
                        lbtthongbao.Text = "Bạn phải nhập ngày trả đơn theo định dạng (dd/MM/yyyy) !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                    DateTime NgayTraDon = DateTime.Parse(txtTradon_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayTraDon < dNgayGQ)
                    {
                        lbtthongbao.Text = "Ngày trả đơn không được nhỏ hơn ngày GQ/YC !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                    if (NgayTraDon > DateTime.Now)
                    {
                        lbtthongbao.Text = "Ngày trả đơn không được lớn hơn ngày hiện tại !";
                        txtTradon_Ngay.Focus();
                        return false;
                    }
                }
            }
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon)
            {
                if (txtYCBS.Text.Length > 1000)
                {
                    lbtthongbao.Text = "Yêu cầu bổ sung không quá 1000 ký tự !";
                    txtYCBS.Focus();
                    return false;
                }
            }
            if (bienphap != ENUM_ADS_BIENPHAPGQ.ADS_ThuLy && bienphap != ENUM_ADS_BIENPHAPGQ.ADS_DonTrung)
            {
                //Ngay thong bao----------------------------
                if (String.IsNullOrEmpty(txtSothongbao.Text))
                {
                    String strMsg = "";
                    strMsg = "Chưa nhập Số Thông báo";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtSothongbao.Focus();
                    return false;
                }
                if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                {
                    String strMsg = "";
                    strMsg = "Chưa nhập Ngày thông báo";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    txtNgaythongbao.Focus();
                    return false;
                }
            }
            if (txtLyDo.Text.Length > 500)
            {
                if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon)
                {
                    lbtthongbao.Text = "Ghi chú không quá 500 ký tự !";
                }
                else
                {
                    lbtthongbao.Text = "Lý do không quá 500 ký tự !";
                }
                txtLyDo.Focus();
                return false;
            }
            // ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == DONID).FirstOrDefault();
            // if (oTD != null)
            // {
            //     lbtthongbao.Text = "Bạn không thể lưu khi đã tống đạt!";
            //     return false;
            // }
            
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
            {
                lbtthongbao.Text = "Bạn không thể lưu khi đã thụ lý sơ thẩm!";
                return false;
            }
            return true;
        }

        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "", bienphap = dropBienPhapGQ.SelectedValue;
            decimal DONID = Convert.ToDecimal(current_id);
            if (!CheckValid(DONID))
            {
                return;
            }
            decimal xuLyID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            ALD_DON_XULY oXuLy = dt.ALD_DON_XULY.Where(x => x.ID == xuLyID).FirstOrDefault();

            ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();

            DON_YEUCAU_BOSUNG obj = new DON_YEUCAU_BOSUNG();
            decimal FileID = 0;
            decimal ToaAnCuEdit = 0;
            #region Tạo xử lý đơn Bang Don_xuly
            ALD_DON_BL oBL = new ALD_DON_BL();
            ADS_DON_XULY_BL oBLYC = new ADS_DON_XULY_BL();
            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
            {
                obj.ID = Convert.ToDecimal(hddCurrID.Value);
                DataTable o = oBLYC.GET_DON_YCBS_GETBYDONID(obj.ID);
            }
            DataTable checkGQ = oBLYC.CHECK_NGAYGQ_DON_YCBS(obj.ID, xuLyID, 5, txtNgayGQ.Text);
            if (checkGQ.Rows.Count > 0)
            {
                DateTime ngayGQNew = Convert.ToDateTime(txtNgayGQ.Text);
                DateTime ngayGQ = Convert.ToDateTime(checkGQ.Rows[0]["NGAYGQ_YC"].ToString());
                if(ngayGQNew > ngayGQ)
                {
                    lbtthongbao.Text = "Ngày GQ/YC không được lớn hơn ngày GQ/YC " + ngayGQ.ToString("dd/MM/yyyy") + " của thông báo số " + checkGQ.Rows[0]["SOTHONGBAO"].ToString() + checkGQ.Rows[0]["STB_PHU"].ToString() + "!";
                }
                else lbtthongbao.Text = "Ngày GQ/YC không được nhỏ hơn ngày GQ/YC " + ngayGQ.ToString("dd/MM/yyyy") + " của thông báo số " + checkGQ.Rows[0]["SOTHONGBAO"].ToString() + checkGQ.Rows[0]["STB_PHU"].ToString() + "!";
                txtNgayGQ.Focus();
                return;
            }
            if (txtSothongbao.Text != "")
            {
                int vNam;
                if (txtNgaythongbao.Text != "")
                {
                    DateTime vdate = DateTime.Parse(txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
                    vNam = vdate.Year;
                }
                else
                    vNam = DateTime.Now.Year;


                decimal check = oBL.CHECKSTT_ALD((decimal)oDon.TOAANID, (decimal)oDon.MAGIAIDOAN, vNam, 0, Convert.ToDecimal(txtSothongbao.Text), ddlStbPhu.SelectedValue, obj.ID);
                DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                String strMsg = "";
                ALD_DON_BL oBL_STB = new ALD_DON_BL();
                String STTNew = oBL_STB.GET_STB_XLDon_NEW_V2((decimal)oDon.TOAANID, "ALD", ngaythongbao).ToString();
                if (check > 0)
                {
                    //strMsg = "Số thông báo " + txtSothongbao.Text + ddlStbPhu.SelectedValue + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                    strMsg = "Số thông báo " + txtSothongbao.Text + ddlStbPhu.SelectedValue + " đã có trong hệ thống.";
                    
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    //20250512: Chỉ thông báo, vãn lưu STB bình thường
                    //txtSothongbao.Text = STTNew;
                    //ddlStbPhu.SelectedValue = "";
                    //txtSothongbao.Focus();
                    //return;
                }
                else
                {
                    obj.SOTHONGBAO = txtSothongbao.Text;
                }
            }

            obj.SOTHONGBAO = txtSothongbao.Text;
            obj.STB_PHU = ddlStbPhu.SelectedValue;
            obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.LYDO = txtLyDo.Text.Trim();
            obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.DONID = oXuLy.DONID;
            obj.DON_CHITIETID = oXuLy.DON_CHITIETID;
            obj.DON_XULYID = oXuLy.DON_XULYID;
            obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            obj.DON_XULY_YCBS_ID = oXuLy.ID;
            obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
            obj.LOAIAN = 5;
            obj.SOHIEU = txtSoHieu.Text;
            obj.NGAYBOSUNG = (String.IsNullOrEmpty(txtNgayBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            decimal rFileID = 0;
            switch (bienphap)
            {
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:

                    obj.CDTN_TOAANID = hddToaAn.Value == "" ? 0 : Convert.ToDecimal(hddToaAn.Value);
                    //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.CDTN_NGAYCHUYEN = DateTime.Now;
                    obj.TRADON_CANCUID = 0;
                    obj.CDNN_TENCQ = "";
                    #region Thiều
                    rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    #endregion

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
                    #region Thiều
                    rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    #endregion
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.YCBS_NOIDUNG = txtYCBS.Text;
                    obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Text.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Text.Trim());
                    #region Thiều
                    rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO, obj.STB_PHU);
                    if (rFileID > 0) obj.FILEID = rFileID;
                    #endregion

                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_DonTrung:
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";
                    break;
                default://Thụ lý
                    obj.TRADON_CANCUID = 0;
                    obj.CDTN_NGAYNHAN = DateTime.MinValue;
                    obj.CDTN_TOAANID = 0;
                    obj.CDNN_TENCQ = "";

                    DM_QHPL_TK qhpl_tk = dt.DM_QHPL_TK.Where(x => x.ID == oDon.QHPLTKID).FirstOrDefault();
                    if (qhpl_tk.OPTIONS == 1)
                    {
                        rFileID = UploadFileID(oDon, FileID, "05-VDS", obj.SOTHONGBAO, obj.STB_PHU);
                        if (rFileID > 0) obj.FILEID = rFileID;
                    }
                    else if (qhpl_tk.OPTIONS == 0)
                    {
                        rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO, obj.STB_PHU);
                        if (rFileID > 0) obj.FILEID = rFileID;
                    }

                    break;
            }

            if (obj.ID == 0)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            oBLYC.DON_YCBS_INUP(obj);
            ALD_DON_XULY objXuLy = dt.ALD_DON_XULY.Where(x => x.ID == obj.DON_XULY_YCBS_ID).FirstOrDefault();
            objXuLy.DONID = obj.DONID;
            objXuLy.DON_XULYID = obj.DON_XULYID;
            objXuLy.LOAIGIAIQUYET = obj.LOAIGIAIQUYET;
            objXuLy.NGAYGQ_YC = obj.NGAYGQ_YC;
            objXuLy.LYDO = obj.LYDO;
            objXuLy.CDTN_TOAANID = obj.CDTN_TOAANID;
            objXuLy.CDTN_NGAYNHAN = obj.CDTN_NGAYNHAN;
            objXuLy.CDNN_TENCQ = obj.CDNN_TENCQ;
            objXuLy.TRADON_CANCUID = obj.TRADON_CANCUID;
            objXuLy.NGAYSUA = DateTime.Now;
            objXuLy.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objXuLy.CDNN_NGAYCHUYEN = obj.CDNN_NGAYCHUYEN;
            objXuLy.TRADON_LYDOID = obj.TRADON_LYDOID;
            objXuLy.TRADON_NGAYTRA = obj.TRADON_NGAYTRA;
            objXuLy.YCBS_NGAYYEUCAU = obj.YCBS_NGAYYEUCAU;
            objXuLy.YCBS_NOIDUNG = obj.YCBS_NOIDUNG;
            objXuLy.CDTN_NGAYCHUYEN = obj.CDTN_NGAYCHUYEN;
            objXuLy.SOTHONGBAO = obj.SOTHONGBAO;
            objXuLy.FILEID = obj.FILEID;
            objXuLy.YCBS_THOIHAN = obj.YCBS_THOIHAN;
            objXuLy.TOAANID = obj.TOAANID;
            objXuLy.NGAYTHONGBAO = obj.NGAYTHONGBAO;
            objXuLy.DON_CHITIETID = obj.DON_CHITIETID;
            objXuLy.STB_PHU = obj.STB_PHU;
            DataTable oDT = oBLYC.ALD_GETALL_DON_YCBS(DONID, objXuLy.ID, 1, 1);
            if (obj.ID == 0 || obj.ID + "" == oDT.Rows[0]["ID"] + "")
            {
                dt.SaveChanges();
            }
            if (bienphap == ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh)
            {
                oDon.LOAIDON = 2;
                dt.SaveChanges();
                ChuyenDonSangToaAnMoi(oDon, obj.ID, objXuLy, ToaAnCuEdit);
            }
            #endregion
            #region Thiều
            UpdateTrangThaiDonKK();
            #endregion
            Reset();
            LoadDSTL();

            DataTable objYCBS = oBLYC.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), obj.DON_XULY_YCBS_ID.Value, 1, 20);
            validateEnableButtonLuu(objYCBS);

            lbtthongbao.Text = "Lưu thành công!";
        }
        private decimal UploadFileID(ALD_DON oDon, decimal FileID, string strMaBieumau, string STT, string STB_PHU)
        {
            ALD_DON_BL oBL = new ALD_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            ALD_FILE objFile = new ALD_FILE();
            if (FileID > 0)
                objFile = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
            objFile.LOAIFILE = 0;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        objFile.NOIDUNG = buff;
                        objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                        objFile.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbtthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            if (STT != "") objFile.STT = Convert.ToDecimal(STT);
            objFile.STB_PHU = STB_PHU;
            
            // quyennd
            if (objFile.TOA_GIAIQUYET_ID == null)
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            
            if (FileID == 0)
                dt.ALD_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private void ChuyenDonSangToaAnMoi(ALD_DON oDon, decimal DonXyLyID, ALD_DON_XULY obj, decimal ToaAnCuEdit)
        {
            if (DonXyLyID == 0)
            {
                ALD_DON oDonMoi = new ALD_DON();

                //oDonMoi.MAVUVIEC = oDon.MAVUVIEC;//////
                oDonMoi.TENVUVIEC = oDon.TENVUVIEC;
                oDonMoi.SOTHUTU = oDon.SOTHUTU;
                oDonMoi.HINHTHUCNHANDON = oDon.HINHTHUCNHANDON;
                oDonMoi.NGAYVIETDON = oDon.NGAYVIETDON;
                oDonMoi.NGAYNHANDON = oDon.NGAYNHANDON;
                oDonMoi.LOAIQUANHE = oDon.LOAIQUANHE;
                oDonMoi.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                oDonMoi.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                oDonMoi.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                oDonMoi.USERTT_EMAIL = oDon.USERTT_EMAIL;
                oDonMoi.USERTT_ID = oDon.USERTT_ID;
                oDonMoi.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                oDonMoi.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                oDonMoi.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;
                oDonMoi.NGUOITAO = oDon.NGUOITAO;
                oDonMoi.NGAYTAO = oDon.NGAYTAO;
                oDonMoi.NGUOISUA = oDon.NGUOISUA;
                oDonMoi.NGAYSUA = oDon.NGAYSUA;
                //oDonMoi.TT = oDon.TT;
                oDonMoi.MAGIAIDOAN = oDon.MAGIAIDOAN;
                oDonMoi.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                oDonMoi.MABAOMAT = oDon.MABAOMAT;
                oDonMoi.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDonMoi.QHPLTKID = oDon.QHPLTKID;
                //oDonMoi.THONGTINTHEM = oDon.THONGTINTHEM;
                oDonMoi.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDonMoi.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                //oDonMoi.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                //mã vụ việc sinh ra thao tòa án mới
                
                ALD_DON_BL dsBL = new ALD_DON_BL();
                oDonMoi.TOAANID = obj.CDTN_TOAANID;
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDonMoi.TOAANID.Value).FirstOrDefault();
                oDonMoi.TT = dsBL.GETNEWTT((decimal)oDonMoi.TOAANID);
                oDonMoi.MAVUVIEC = ENUM_LOAIVUVIEC.AN_LAODONG + oTA.MA + oDonMoi.TT.ToString();
                oDonMoi.CANBONHANDONID = 0;
                oDonMoi.THAMPHANKYNHANDON = 0;
                oDonMoi.LOAIDON = 1;
                oDonMoi.TRANGTHAI = 0;
                //lưu id đơn cũ khi chuyển đơn sang tòa án khác
                oDonMoi.DONID_TOACU = oDon.DONID_TOACU.HasValue ? oDon.DONID_TOACU.Value : oDon.ID;
                oDonMoi.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.ALD_DON.Add(oDonMoi);
                dt.SaveChanges();

                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("5", oDonMoi.ID, 2, obj.CDTN_TOAANID.Value, 0, 0, 0, 0);
                List<DuongSuTemp> lstDuongSuTemp = new List<DuongSuTemp>();

                //lấy danh sách đương sự
                IQueryable<ALD_DON_DUONGSU> lstoDS = dt.ALD_DON_DUONGSU.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstoDS)
                {
                    ALD_DON_DUONGSU oDS = new ALD_DON_DUONGSU();
                    oDS.DONID = oDonMoi.ID;
                    oDS.MADUONGSU = item.MADUONGSU;
                    oDS.TENDUONGSU = item.TENDUONGSU;
                    oDS.ISDAIDIEN = item.ISDAIDIEN;
                    oDS.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                    oDS.LOAIDUONGSU = item.LOAIDUONGSU;
                    oDS.SOCMND = item.SOCMND;
                    oDS.QUOCTICHID = item.QUOCTICHID;
                    oDS.TAMTRUID = item.TAMTRUID;
                    oDS.TAMTRUCHITIET = item.TAMTRUCHITIET;
                    oDS.HKTTID = item.HKTTID;
                    oDS.HKTTCHITIET = item.HKTTCHITIET;
                    oDS.NGAYSINH = item.NGAYSINH;
                    oDS.THANGSINH = item.THANGSINH;
                    oDS.NAMSINH = item.NAMSINH;
                    oDS.GIOITINH = item.GIOITINH;
                    oDS.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    oDS.CHUCVU = item.CHUCVU;
                    oDS.NGUOITAO = item.NGUOITAO;
                    oDS.NGAYTAO = item.NGAYTAO;
                    oDS.NGUOISUA = item.NGUOISUA;
                    oDS.NGAYSUA = item.NGAYSUA;
                    oDS.NDD_DIACHIID = item.NDD_DIACHIID;
                    oDS.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                    oDS.ISSOTHAM = item.ISSOTHAM;
                    oDS.ISPHUCTHAM = item.ISPHUCTHAM;
                    oDS.ISGDT = item.ISGDT;
                    oDS.ISDON = item.ISDON;
                    oDS.EMAIL = item.EMAIL;
                    oDS.DIENTHOAI = item.DIENTHOAI;
                    oDS.FAX = item.FAX;
                    oDS.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                    oDS.HKTTTINHID = item.HKTTTINHID;
                    oDS.TAMTRUTINHID = item.TAMTRUTINHID;
                    oDS.ISBVQLNGUOIKHAC = item.ISBVQLNGUOIKHAC;
                    oDS.TUOI = item.TUOI;
                    oDS.DIACHICOQUAN = item.DIACHICOQUAN;
                    oDS.ID_DUONGSU_TACC = item.ID_DUONGSU_TACC;
                    
                    // quyennd
                    if (oDS.TOA_GIAIQUYET_ID == null)
                        oDS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.ALD_DON_DUONGSU.Add(oDS);
                    dt.SaveChanges();

                    lstDuongSuTemp.Add(new DuongSuTemp(item.ID, oDS.ID));
                }


                //lấy danh sách người tham gia tố tụng
                IQueryable<ALD_DON_THAMGIATOTUNG> lstoTT = dt.ALD_DON_THAMGIATOTUNG.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstoTT)
                {
                    //lưu thông tin người tham gia tố tụng
                    ALD_DON_THAMGIATOTUNG oTT = new ALD_DON_THAMGIATOTUNG();
                    oTT.DONID = oDonMoi.ID;
                    oTT.HOTEN = item.HOTEN;
                    oTT.TAMTRUID = item.TAMTRUID;
                    oTT.TAMTRUCHITIET = item.TAMTRUCHITIET;
                    oTT.HKTTID = item.HKTTID;
                    oTT.HKTTCHITIET = item.HKTTCHITIET;
                    oTT.NGAYSINH = item.NGAYSINH;
                    oTT.THANGSINH = item.THANGSINH;
                    oTT.NAMSINH = item.NAMSINH;
                    oTT.GIOITINH = item.GIOITINH;
                    oTT.TUCACHTGTTID = item.TUCACHTGTTID;
                    oTT.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                    oTT.CHUCVU = item.CHUCVU;
                    oTT.NGAYTHAMGIA = item.NGAYTHAMGIA;
                    oTT.NGAYKETTHUC = item.NGAYKETTHUC;
                    oTT.NGAYTAO = item.NGAYTAO;
                    oTT.NGUOITAO = item.NGUOITAO;
                    oTT.NGAYSUA = item.NGAYSUA;
                    oTT.NGUOISUA = item.NGUOISUA;
                    oTT.EMAIL = item.EMAIL;
                    oTT.DIENTHOAI = item.DIENTHOAI;
                    oTT.FAX = item.FAX;
                    oTT.HKTTTINHID = item.HKTTTINHID;
                    oTT.TAMTRUTINHID = item.TAMTRUTINHID;
                    oTT.ID_DUONGSU_TACC = item.ID_DUONGSU_TACC;
                    UpdateDuongSuIdTGTT(item, oTT, lstDuongSuTemp);
                    //oTT.DUONGSUID = item.DUONGSUID;
                    
                    // quyennd
                    if (oTT.TOA_GIAIQUYET_ID == null)
                        oTT.TOA_GIAIQUYET_ID = item.TOA_GIAIQUYET_ID;

                    dt.ALD_DON_THAMGIATOTUNG.Add(oTT);
                    dt.SaveChanges();
                }


                IQueryable<ALD_DON_TAILIEU> lstTailieu = dt.ALD_DON_TAILIEU.Where(s => s.DONID == oDon.ID);
                foreach (var item in lstTailieu)
                {
                    ALD_DON_TAILIEU objtl = new ALD_DON_TAILIEU();
                    objtl.DONID = oDonMoi.ID;
                    objtl.TENTAILIEU = item.TENTAILIEU;
                    objtl.TENFILE = item.TENFILE;
                    objtl.LOAIFILE = item.LOAIFILE;
                    objtl.NOIDUNG = item.NOIDUNG;
                    objtl.NGUOITAO = item.NGUOITAO;
                    objtl.NGAYTAO = item.NGAYTAO;
                    objtl.NGUOISUA = item.NGUOISUA;
                    objtl.NGAYSUA = item.NGAYSUA;
                    objtl.BANGIAOID = item.BANGIAOID;
                    objtl.NGAYBANGIAO = item.NGAYBANGIAO;
                    objtl.NGUOIBANGIAO = item.NGUOIBANGIAO;
                    objtl.LOAIDOITUONG = item.LOAIDOITUONG;
                    objtl.NGUOINHANID = item.NGUOINHANID;
                    
                    // quyennd
                    if (obj.TOA_GIAIQUYET_ID == null)
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.ALD_DON_TAILIEU.Add(objtl);
                    dt.SaveChanges();
                }
            }
            else
            {
                ///
                //kiểm tra tòa án mới xem có sửa hay không, nếu có thì thay dổi, không thì thôi
                ALD_DON oDonNew = dt.ALD_DON.FirstOrDefault(s => s.DONID_TOACU == obj.DONID && s.TOAANID == ToaAnCuEdit);
                if (oDonNew != null)
                {
                    if (oDonNew.TOAANID.Value != obj.CDTN_TOAANID)
                    {
                        //cập nhật lại thông tin tòa án
                        ALD_DON_BL dsBL = new ALD_DON_BL();
                        oDonNew.TOAANID = obj.CDTN_TOAANID;
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDonNew.TOAANID.Value).FirstOrDefault();
                        oDonNew.TT = dsBL.GETNEWTT((decimal)oDonNew.TOAANID);
                        oDonNew.MAVUVIEC = ENUM_LOAIVUVIEC.AN_LAODONG + oTA.MA + oDonNew.TT.ToString();
                        dt.SaveChanges();

                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_UPDATE("5", oDonNew.ID, 2, Convert.ToDecimal(oDonNew.TOAANID), 0, 0, 0, 0);
                    }
                }

            }
        }
        class DuongSuTemp
        {
            public decimal DuongSuIdOld { get; set; }
            public decimal DuongSuIdNew { get; set; }
            public DuongSuTemp(decimal DuongSuIdOld, decimal DuongSuIdNew)
            {
                this.DuongSuIdOld = DuongSuIdOld;
                this.DuongSuIdNew = DuongSuIdNew;
            }
        }
        private void UpdateDuongSuIdTGTT(ALD_DON_THAMGIATOTUNG oTTOLD, ALD_DON_THAMGIATOTUNG oTTNEW, List<DuongSuTemp> lstDuongSuTemp)
        {
            string[] arrDuongSuId = oTTOLD.DUONGSUID.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (arrDuongSuId.Length > 0)
            {
                List<decimal> lstDuongSuIdOld = arrDuongSuId.Select(s => Convert.ToDecimal(s)).ToList();
                string strDuongSuIdNew = string.Join(",", lstDuongSuTemp.Where(s => lstDuongSuIdOld.Contains(s.DuongSuIdOld)).Select(s => s.DuongSuIdNew));
                if (strDuongSuIdNew.Length > 1)
                {
                    strDuongSuIdNew = "," + strDuongSuIdNew + ",";
                }
                oTTNEW.DUONGSUID = strDuongSuIdNew;
            }
        }
        void UpdateTrangThaiDonKK()
        {
            int bienphap_gd = Convert.ToInt16(dropBienPhapGQ.SelectedValue);
            string loai_an = ENUM_LOAIAN.AN_LAODONG + "";
            decimal vuviecid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            string yeucau = "";
            switch (bienphap_gd)
            {
                case 1:
                    //chuyen don trong he thong
                    yeucau = txtToaAn.Text.Trim();
                    break;
                //case 2:
                //    //chuyen don trong he thong
                //    yeucau = txtToaAn.Text.Trim();
                //    break;
                case 3:
                    //tra lai don
                    yeucau = ddlLyTradon.SelectedItem.Text;
                    break;
                case 4:
                    //yeu cau bo sung
                    yeucau = txtYCBS.Text.Trim();
                    break;
            }
            try
            {
                //DAL.DKK.DKKContextContainer dkk_dt = new DAL.DKK.DKKContextContainer();
                BL.DonKK.DONKK_DON_BL objDonKK = new BL.DonKK.DONKK_DON_BL();
                objDonKK.UpdateTrangThaiDonKK(bienphap_gd, yeucau, loai_an, vuviecid);
            }
            catch (Exception ex) { }
        }

        protected void dropBienPhapGQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblNgayGQ.Text = "Ngày GQ/YC";
            lblLydo.Text = "Lý do";
            string bienphap = dropBienPhapGQ.SelectedValue;
            switch (bienphap)
            {
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:

                    pnCDNN.Visible = pnBoSung.Visible = true;
                    pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                    //lblNgayGQ.Text = "Ngày chuyển";
                    pnCDTN.Visible = pnBoSung.Visible = true;
                    pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                    //DONGHEP.Visible = true;
                    pnTraDon.Visible = pnBoSung.Visible = true;
                    pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                    lblLydo.Text = "Ghi chú";
                    pnThongbao.Visible = true;
                    break;
                case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                    //DONGHEP.Visible = true;
                    pnYCBS.Visible = true;
                    pnTraDon.Visible = pnBoSung.Visible = false;
                    pnCDTN.Visible = pnCDNN.Visible = false;
                    pnThongbao.Visible = true;
                    break;
                default:
                    pnBoSung.Visible = true;
                    pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                    pnThongbao.Visible = false;
                    break;
            }
            txtNgayGQ.Focus();
        }

        protected void txtNgaythongbao_TextChanged1(object sender, EventArgs e)
        {
            if (hddCurrID.Value == "0" || hddCurrID.Value == "")
                SetNewSoTB();
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            Reset();
        }
        protected void Reset()
        {
            hddCurrID.Value = "0";
            txtCDNN_TenCoQuan.Text = txtCDNN_NgayChuyen.Text = txtLyDo.Text = txtNgaythongbao.Text = txtNgayBS.Text = txtSoHieu.Text = "";
            txtNgayGQ.Text = txtToaAn.Text = "";
            txtSothongbao.Text = txtThoihanBSYC.Text = txtYCBS.Text = "";
            //txtSothongbao.Enabled = true;
            hddToaAn.Value = "0";
            dropBienPhapGQ.Enabled = true;
            ddlStbPhu.SelectedValue = "";

            decimal xuLyID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ADS_DON_XULY_BL oBLYC1 = new ADS_DON_XULY_BL();
            DataTable donYCBS = oBLYC1.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), xuLyID, 1, 20);
            validateEnableButtonLuu(donYCBS);
        }
        void LoadInfo(Decimal CurrID)
        {
            ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
            DataTable obj = oBL.GET_DON_YCBS_GETBYDONID(CurrID);
            if (obj != null)
            {
                Cls_Comon.SetButton(cmdCapNhat, true);
                Cls_Comon.SetButton(cmdLammoi, true);
                if ((obj.Rows[0]["CDTN_TOAANID"].ToString() + "") == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                {
                    lbtthongbao.Text = "Bạn không thể sửa nội dung của tòa án khác cập nhật!";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                }
                if (((DateTime)obj.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy") != "01/01/0001")
                    txtNgayBS.Text = ((DateTime)obj.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy", cul);
                txtSoHieu.Text = obj.Rows[0]["SOHIEU"].ToString();
                txtNgayGQ.Text = ((DateTime)obj.Rows[0]["NGAYGQ_YC"]).ToString("dd/MM/yyyy");
                txtLyDo.Text = obj.Rows[0]["LYDO"] + "";
                txtNgaythongbao.Text = obj.Rows[0]["NGAYTHONGBAO"] + "" == "" ? "" : ((DateTime)obj.Rows[0]["NGAYTHONGBAO"]).ToString("dd/MM/yyyy");
                txtSothongbao.Text = obj.Rows[0]["SOTHONGBAO"].ToString();
                ddlStbPhu.SelectedValue = obj.Rows[0]["STB_PHU"].ToString();
                //txtSothongbao.Enabled = false;
                dropBienPhapGQ.SelectedValue = obj.Rows[0]["LOAIGIAIQUYET"] + "";
                string bienphap = dropBienPhapGQ.SelectedValue;
                lblNgayGQ.Text = "Ngày GQ/YC";
                lblLydo.Text = "Lý do";
                switch (bienphap)
                {
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                        pnCDNN.Visible = pnBoSung.Visible = true;
                        pnCDTN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        pnThongbao.Visible = true;
                        txtCDNN_NgayChuyen.Text = (((DateTime)(obj.Rows[0]["CDNN_NGAYCHUYEN"])) == DateTime.MinValue) ? "" : ((DateTime)(obj.Rows[0]["CDNN_NGAYCHUYEN"])).ToString("dd/MM/yyyy", cul);
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                        pnCDTN.Visible = pnBoSung.Visible = true;
                        pnCDNN.Visible = pnTraDon.Visible = pnYCBS.Visible = false;
                        pnThongbao.Visible = true;
                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                        pnTraDon.Visible = pnBoSung.Visible = true;
                        pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                        lblLydo.Text = "Ghi chú";
                        pnThongbao.Visible = true;
                        txtTradon_Ngay.Text = (((DateTime)(obj.Rows[0]["TRADON_NGAYTRA"])) == DateTime.MinValue) ? "" : ((DateTime)(obj.Rows[0]["TRADON_NGAYTRA"])).ToString("dd/MM/yyyy", cul);
                        if (obj.Rows[0]["TRADON_LYDOID"] + "" != "")
                            ddlLyTradon.SelectedValue = obj.Rows[0]["TRADON_LYDOID"].ToString();

                        break;
                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                        pnYCBS.Visible = true;
                        pnTraDon.Visible = pnBoSung.Visible = false;
                        pnCDTN.Visible = pnCDNN.Visible = false;
                        pnThongbao.Visible = true;
                        txtYCBS.Text = obj.Rows[0]["YCBS_NOIDUNG"] + "";
                        txtThoihanBSYC.Text = obj.Rows[0]["YCBS_THOIHAN"] + "" == "" ? "" : Convert.ToDecimal(obj.Rows[0]["YCBS_THOIHAN"]).ToString();

                        break;
                    default:
                        pnBoSung.Visible = true;
                        pnCDNN.Visible = pnCDTN.Visible = pnYCBS.Visible = pnTraDon.Visible = false;
                        pnThongbao.Visible = false;
                        break;
                }
                decimal cdtn_toaanid = Convert.ToDecimal(obj.Rows[0]["CDTN_TOAANID"].ToString());
                if (cdtn_toaanid > 0)
                {
                    hddToaAn.Value = obj.Rows[0]["CDTN_TOAANID"].ToString();
                    txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == cdtn_toaanid).Single<DM_TOAAN>().MA_TEN;
                }
                txtCDNN_TenCoQuan.Text = obj.Rows[0]["CDNN_TENCQ"] + "";
            }

        }
        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            
            switch (e.CommandName)
            {
                case "Sua":
                    hddCurrID.Value = ID.ToString();
                    lbtthongbao.Text = "";
                    dropBienPhapGQ.Enabled = true;
                    if (e.Item.ItemIndex != 0)
                    {
                        dropBienPhapGQ.Enabled = false;
                    }
                    enableAllItem(true);
                    LoadInfo(ID);

                    validateEnableButton(DONID, ID);

                    break;
                case "Xoa":
                    ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
                    {
                        lbtthongbao.Text = "Bạn không thể xóa khi thụ lý sơ thẩm!";
                        break;
                    }
                    
                    ADS_DON_XULY_BL oBLDel = new ADS_DON_XULY_BL();
                    oBLDel.DEL_DON_YCBS_GETBYDONID(ID);
                   
                    decimal ID_DON_YCBS = Convert.ToDecimal(Request.QueryString["ID"].ToString());
                    DataTable obj = oBLDel.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), ID_DON_YCBS, 1, 20);
                    if (e.Item.ItemIndex == 0 && obj.Rows.Count > 0)
                    {
                        ALD_DON_XULY objXuLy = dt.ALD_DON_XULY.Where(x => x.ID == ID_DON_YCBS).FirstOrDefault();
                        objXuLy.LOAIGIAIQUYET = Convert.ToDecimal(obj.Rows[0]["LOAIGIAIQUYET"]);
                        objXuLy.NGAYGQ_YC = Convert.ToDateTime(obj.Rows[0]["NGAYGQ_YC"]);
                        objXuLy.LYDO = obj.Rows[0]["LYDO"].ToString();
                        if (obj.Rows[0]["CDTN_TOAANID"] + "" != "") objXuLy.CDTN_TOAANID = Convert.ToDecimal(obj.Rows[0]["CDTN_TOAANID"]);
                        if (obj.Rows[0]["CDTN_NGAYNHAN"] + "" != "") objXuLy.CDTN_NGAYNHAN = Convert.ToDateTime(obj.Rows[0]["CDTN_NGAYNHAN"]);
                        objXuLy.CDNN_TENCQ = obj.Rows[0]["CDNN_TENCQ"].ToString();
                        if (obj.Rows[0]["TRADON_CANCUID"] + "" != "") objXuLy.TRADON_CANCUID = Convert.ToDecimal(obj.Rows[0]["TRADON_CANCUID"]);
                        objXuLy.NGAYSUA = DateTime.Now;
                        objXuLy.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        if (obj.Rows[0]["CDNN_NGAYCHUYEN"] + "" != "") objXuLy.CDNN_NGAYCHUYEN = Convert.ToDateTime(obj.Rows[0]["CDNN_NGAYCHUYEN"]);
                        if (obj.Rows[0]["TRADON_LYDOID"] + "" != "") objXuLy.TRADON_LYDOID = Convert.ToDecimal(obj.Rows[0]["TRADON_LYDOID"]);
                        if (obj.Rows[0]["TRADON_NGAYTRA"] + "" != "") objXuLy.TRADON_NGAYTRA = Convert.ToDateTime(obj.Rows[0]["TRADON_NGAYTRA"]);
                        if (obj.Rows[0]["YCBS_NGAYYEUCAU"] + "" != "") objXuLy.YCBS_NGAYYEUCAU = Convert.ToDateTime(obj.Rows[0]["YCBS_NGAYYEUCAU"]);
                        objXuLy.YCBS_NOIDUNG = obj.Rows[0]["YCBS_NOIDUNG"].ToString();
                        if (obj.Rows[0]["CDTN_NGAYCHUYEN"] + "" != "") objXuLy.CDTN_NGAYCHUYEN = Convert.ToDateTime(obj.Rows[0]["CDTN_NGAYCHUYEN"]);
                        objXuLy.SOTHONGBAO = obj.Rows[0]["SOTHONGBAO"].ToString();
                        if (obj.Rows[0]["FILEID"] + "" != "") objXuLy.FILEID = Convert.ToDecimal(obj.Rows[0]["FILEID"]);
                        if (obj.Rows[0]["YCBS_THOIHAN"] + "" != "") objXuLy.YCBS_THOIHAN = Convert.ToDecimal(obj.Rows[0]["YCBS_THOIHAN"]);
                        objXuLy.TOAANID = Convert.ToDecimal(obj.Rows[0]["TOAANID"]);
                        if (obj.Rows[0]["NGAYTHONGBAO"] + "" != "") objXuLy.NGAYTHONGBAO = Convert.ToDateTime(obj.Rows[0]["NGAYTHONGBAO"]);
                        objXuLy.STB_PHU = obj.Rows[0]["STB_PHU"].ToString();


                        decimal FileID = 0;
                        if (objXuLy.FILEID != null) FileID = (decimal)objXuLy.FILEID;
                        if (FileID > 0)
                        {
                            try
                            {
                                ALD_FILE objf = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                                dt.ALD_FILE.Remove(objf);
                                dt.SaveChanges();
                            }
                            catch (Exception ex)
                            {
                                lbtthongbao.Text = "Lỗi khi xóa xử lý đơn!"; ;
                            }
                        }

                        dt.SaveChanges();
                    }

                    if (obj.Rows.Count == 0)
                    {
                        ALD_DON_XULY objXuLy = dt.ALD_DON_XULY.Where(x => x.ID == ID_DON_YCBS).FirstOrDefault();
                        dt.ALD_DON_XULY.Remove(objXuLy);
                    }
                    string mess = "Xóa thành công!";
                    LoadDSTL();
                    Reset();

                    validateEnableButtonLuu(obj);

                    lbtthongbao.Text = mess;
                    break;
                case "ChiTiet":
                    hddCurrID.Value = ID.ToString();
                    lbtthongbao.Text = "";
                    LoadInfo(ID);
                    enableAllItem(false);
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    break;
            }
        }

        private void validateEnableButton(decimal DONID, decimal DON_YCBSID)
        {
            decimal xuLyID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            ADS_DON_XULY_BL aDXL = new ADS_DON_XULY_BL();
            DataTable objYCBS = aDXL.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), xuLyID, 1, 20);
            bool checkExistThuLy = false;
            bool checkExistTraLaiDon = false;
            decimal DON_YCBS_TRALAIDON_ID = 0;
            decimal DON_YCBS_THULY_ID = 0;
            foreach (DataRow data in objYCBS.Rows)
            {
                if (data["LOAIGIAIQUYET"] + "" == ENUM_ADS_BIENPHAPGQ.ADS_ThuLy)
                {
                    DON_YCBS_THULY_ID = Convert.ToDecimal(data["ID"].ToString());
                    checkExistThuLy = true;
                }
                if (data["LOAIGIAIQUYET"] + "" == ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon)
                {
                    DON_YCBS_TRALAIDON_ID = Convert.ToDecimal(data["ID"].ToString());
                    checkExistTraLaiDon = true;
                }

            }

            if (DON_YCBSID == DON_YCBS_TRALAIDON_ID && checkExistThuLy)
            {
                dropBienPhapGQ.Enabled = false;
                Cls_Comon.SetButton(cmdCapNhat, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else if (DON_YCBSID == DON_YCBS_TRALAIDON_ID && !checkExistThuLy)
            {
                dropBienPhapGQ.Enabled = true;
                Cls_Comon.SetButton(cmdCapNhat, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else if (DON_YCBSID == DON_YCBS_THULY_ID && !checkExistTraLaiDon)
            {
                dropBienPhapGQ.Enabled = true;
                Cls_Comon.SetButton(cmdCapNhat, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else if (!checkExistThuLy && !checkExistTraLaiDon)
            {
                dropBienPhapGQ.Enabled = true;
                Cls_Comon.SetButton(cmdCapNhat, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else
            {
                dropBienPhapGQ.Enabled = false;
                Cls_Comon.SetButton(cmdCapNhat, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
        }

        private void validateEnableButtonLuu(DataTable objYCBS)
        {
            if (objYCBS.Rows.Count > 0)
            {
                bool checkExistThuLy = false;
                bool checkExistTraLaiDon = false;
                foreach (DataRow data in objYCBS.Rows)
                {
                    if (data["LOAIGIAIQUYET"] + "" == ENUM_ADS_BIENPHAPGQ.ADS_ThuLy)
                    {
                        checkExistThuLy = true;
                    }
                    if (data["LOAIGIAIQUYET"] + "" == ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon)
                    {
                        checkExistTraLaiDon = true;
                    }

                }
                if (checkExistThuLy)
                {
                    dropBienPhapGQ.SelectedValue = ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon;
                    dropBienPhapGQ.Enabled = false;

                    pnTraDon.Visible = pnBoSung.Visible = true;
                    pnCDTN.Visible = pnCDNN.Visible = pnYCBS.Visible = false;
                    lblLydo.Text = "Ghi chú";
                    pnThongbao.Visible = true;
                }

                if (checkExistTraLaiDon)
                {
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
                else
                {
                    Cls_Comon.SetButton(cmdCapNhat, true);
                    Cls_Comon.SetButton(cmdLammoi, true);
                }
            }
        }

        private void enableAllItem(bool enable)
        {
            txtCDNN_TenCoQuan.Enabled = txtCDNN_NgayChuyen.Enabled = txtLyDo.Enabled = txtNgaythongbao.Enabled = txtNgayBS.Enabled = txtSoHieu.Enabled = enable;
            txtNgayGQ.Enabled = txtToaAn.Enabled = enable;
            txtSothongbao.Enabled = txtThoihanBSYC.Enabled = txtYCBS.Enabled = enable;
            dropBienPhapGQ.Enabled = enable;
        }

        protected void dgDS_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton cmdEdit = (ImageButton)e.Item.FindControl("cmdEdit");
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                ImageButton cmdView = (ImageButton)e.Item.FindControl("cmdView");
                decimal ID_DON_YCBS = Convert.ToDecimal(Request.QueryString["ID"].ToString());
                ALD_DON_XULY oXL = dt.ALD_DON_XULY.Where(x => x.ID == ID_DON_YCBS).FirstOrDefault();
                decimal? DONID = oXL.DONID == null ? oXL.DON_XULYID : oXL.DONID;
                decimal? DONCHITIETID = oXL.DON_CHITIETID;
                decimal ISDONCHITIET = oXL.DONID == null ? 1 : 0;
                
                ALD_DON_XULY_BL oBL = new ALD_DON_XULY_BL();
                if (e.Item.ItemIndex == 0)
                {
                    cmdEdit.Visible = true;
                    cmdXoa.Visible = true;
                    cmdView.Visible = false;                    
                    DataTable anphiList = oBL.CHECK_ALD_DON_DUONGSU_ANPHI_V2(DONID, DONCHITIETID, ISDONCHITIET);

                   if (anphiList.Rows.Count > 0 && oXL.LOAIGIAIQUYET == 5)
                    {
                        cmdEdit.Visible = false;
                        cmdXoa.Visible = false;
                        cmdView.Visible = true;
                    }
                }
                else
                {
                    cmdEdit.Visible = false;
                    cmdXoa.Visible = false;
                    cmdView.Visible = true;
                }
                ADS_DON_XULY_BL oB = new ADS_DON_XULY_BL();
                // DataTable obj = oB.ALD_GETALL_DON_YCBS(Convert.ToDecimal(DONID), ID_DON_YCBS, 1, 20);
                // if ((obj.Rows.Count - 1) == 0 && (obj.Rows.Count - 1) == e.Item.ItemIndex)
                // {
                //     cmdEdit.Visible = true;
                //     cmdXoa.Visible = false;
                //     cmdView.Visible = false;
                // }

                ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
                {
                    cmdEdit.Visible = false;
                    cmdXoa.Visible = false;
                    cmdView.Visible = true;
                }

            }
        }

        private void LoadDSTL()
        {
            ADS_DON_XULY_BL oBL = new ADS_DON_XULY_BL();
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            decimal ID_DON_YCBS = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            int page_size = 1000;
            int pageindex = 1;

            DataTable oDT = oBL.ALD_GETALL_DON_YCBS(DONID, ID_DON_YCBS, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                dgDS.DataSource = oDT;
                dgDS.DataBind();
            }
        }
    }
}
using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.THA;
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
using System.IO;
using BL.GSTP.AHS;

namespace WEB.GSTP.QLAN.THA.CongVanTHA
{
    public partial class KQGiaiQuyet : System.Web.UI.Page
    {

        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, VuAnID = 0, BiAnID = 0;
        public String NgaySoSanh = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (!IsPostBack)
                {
                    THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                    if (objBA != null)
                        VuAnID = (decimal)objBA.VUANID;
                    LoadDrop();
                    CheckQuyen();
                    Decimal ThuLyCV_ID = String.IsNullOrEmpty(Request["tID"] + "") ? 0 : Convert.ToDecimal(Request["tID"] + "");
                    if (ThuLyCV_ID>0)
                        LoadInfo(ThuLyCV_ID);
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lstMsgTop.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdSave.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lstMsgTop.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdSave.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lstMsgTop.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdSave.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lstMsgTop.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdSave.Visible = false;
                    IsOk = false;
                }
            }
            //-------Kiểm tra có 4.3 Quyết định chưa co roi thi khong hien thi nut Luu-------------------
            Decimal vThuLyCV_ID = String.IsNullOrEmpty(Request["tID"] + "") ? 0 : Convert.ToDecimal(Request["tID"] + "");
            THA_CVDON_QD oCV_QD = null;
            try
            {
                oCV_QD = dt.THA_CVDON_QD.Where(x => x.BIANID == BiAnID
                                                  && x.CVDONID == vThuLyCV_ID).FirstOrDefault();
            }
            catch (Exception ex) { }
            if (oCV_QD != null)
            {
                lstMsgTop.Text = " Đã ra Quyết định tại mục ''4.3 Quyết định''. Bạn không được sửa!";
                cmdSave.Visible = false;
            }
        }

        void LoadDrop()
        {
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

            //-------------chu toa= Tham phan----------------------
            dropChuToa.Items.Clear();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            dropChuToa.DataSource = oCBDT;
            dropChuToa.DataTextField = "HOTEN";
            dropChuToa.DataValueField = "ID";
            dropChuToa.DataBind();
            dropChuToa.Items.Insert(0, new ListItem("--Chọn--", "0"));

            //--------can bo VKS----------------
            dropKSV.Items.Clear();
            //DM_VKS ID_DONVI_VKS = dt.DM_VKS.Where(x => x.TOAANID == donvi).FirstOrDefault();
            dropKSV.Items.Insert(0, new ListItem("--Chọn--", "0"));

            //if(ID_DONVI_VKS != null)
            //{
                DM_CANBOVKS_BL objVKS = new DM_CANBOVKS_BL();
                DataTable tbl = objVKS.DM_CANBOVKS_GETBYDONVI(donvi);
                if (tbl != null && tbl.Rows.Count>0)
                {
                    foreach (DataRow row in tbl.Rows)
                        dropKSV.Items.Add(new ListItem(row["HoTen"] + "", row["ID"] + ""));
                }
            //}

            //-------------Nguoi ky--------------------------
            dropNguoiKy.Items.Clear();
            oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);
            dropNguoiKy.DataSource = oCBDT;
            dropNguoiKy.DataTextField = "HOTEN";
            dropNguoiKy.DataValueField = "ID";
            dropNguoiKy.DataBind();
            dropNguoiKy.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        protected void dropNguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropNguoiKy.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(dropNguoiKy.SelectedValue);
                    decimal ChucVuId = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).Single<DM_CANBO>().CHUCVUID;

                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == ChucVuId).Single<DM_DATAITEM>().TEN;
                }
                catch (Exception ex) { }
            }
        }
        //------------------------
        void LoadInfo(Decimal ThuLyCV_ID)
        {
            THA_CVDON_THULY objThuLy = dt.THA_CVDON_THULY.Where(x=>x.ID == ThuLyCV_ID).Single<THA_CVDON_THULY>();
            if (objThuLy != null)
            {
                Decimal YeuCauID = (Decimal)objThuLy.YEUCAUID;
                try
                {
                    DM_DATAITEM objItem = dt.DM_DATAITEM.Where(x => x.ID == YeuCauID).Single<DM_DATAITEM>();
                    txtYeuCau.Text = objItem.TEN;
                }catch(Exception ex) { }
                if (objThuLy.LOAIDON==0)
                    NgaySoSanh = (String.IsNullOrEmpty(objThuLy.CV_NGAY + "")) ? "" : ((DateTime)objThuLy.CV_NGAY).ToString("dd/MM/yyyy", cul);
                else
                    NgaySoSanh =(String.IsNullOrEmpty(objThuLy.NGAYTHULY+""))? "": ((DateTime)objThuLy.NGAYTHULY).ToString("dd/MM/yyyy", cul);
            }
            //----------------------
            THA_CVDON_KQGQ obj = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == ThuLyCV_ID).SingleOrDefault<THA_CVDON_KQGQ>();
            if (obj != null )
            {
                try { dropChuToa.SelectedValue = obj.CHUTOAID.ToString(); }catch(Exception ex) { }
                try { dropKSV.SelectedValue = obj.KSVID.ToString(); } catch (Exception ex) { }
                rdYKienVKS.SelectedValue = obj.VKSYKIEN.ToString();

                txtNgayMoPhienHop.Text = (((DateTime)obj.NGAYMOPHIENHOP) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYMOPHIENHOP).ToString("dd/MM/yyyy", cul);
                txtNgayKT.Text = (((DateTime)obj.NGAYKETTHUCPHIENHOP) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYKETTHUCPHIENHOP).ToString("dd/MM/yyyy", cul);
                txtSoVB.Text = obj.SOVANBAN;
                txtNgayKyVB.Text = (((DateTime)obj.NGAYVANBAN) == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYVANBAN).ToString("dd/MM/yyyy", cul);

                try { dropNguoiKy.SelectedValue = obj.NGUOIKYID.ToString(); } catch (Exception ex) { }
                txtChucVu.Text = obj.CHUCVU;

                rdKetQua.SelectedValue = obj.LOAIKETQUA + "";
                txtGhiChu.Text = obj.GHICHU;
            }
        }
        //------------------------
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            Boolean IsUpdate = false; ;
            Decimal ThuLyCV_ID = String.IsNullOrEmpty(Request["tID"] + "") ? 0 : Convert.ToDecimal(Request["tID"] + "");
            THA_CVDON_KQGQ obj = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == ThuLyCV_ID).SingleOrDefault<THA_CVDON_KQGQ>();
            if (obj != null)
            {
                IsUpdate = true;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = CurrUserID.ToString();
            }
            else
            {
                IsUpdate = false;
                obj = new THA_CVDON_KQGQ();
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = CurrUserID.ToString();
            }
            obj.BIANID = BiAnID;

            if(VuAnID>0)
                obj.VUANID = VuAnID;
            else
            {
                THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                if (objBA != null)
                    obj.VUANID = (decimal)objBA.VUANID;
            }
            obj.CVDONID = Convert.ToDecimal(Request["tID"] + "");

            obj.CHUTOAID = Convert.ToDecimal(dropChuToa.SelectedValue);
            obj.KSVID = Convert.ToDecimal(dropKSV.SelectedValue);
            obj.VKSYKIEN= Convert.ToDecimal( rdYKienVKS.SelectedValue);

            obj.NGUOIKYID = Convert.ToDecimal(dropNguoiKy.SelectedValue);
            obj.CHUCVU = txtChucVu.Text;

            obj.NGAYMOPHIENHOP = (String.IsNullOrEmpty(txtNgayMoPhienHop.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayMoPhienHop.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYKETTHUCPHIENHOP = (String.IsNullOrEmpty(txtNgayKT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        
            obj.SOVANBAN=txtSoVB.Text;
            obj.NGAYVANBAN = (String.IsNullOrEmpty(txtNgayKyVB.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKyVB.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            obj.LOAIKETQUA = Convert.ToDecimal(rdKetQua.SelectedValue);
            obj.GHICHU=txtGhiChu.Text;
            
            if (!IsUpdate)
            {
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_CVDON_KQGQ.Add(obj);
            }
                
            dt.SaveChanges();
           // clear_form();
            lttMsg.Text = "Lưu kết quả giải quyết công văn/đơn thành công!";
        }
        void clear_form()
        {
            rdKetQua.SelectedValue = rdYKienVKS.SelectedValue = "0";
            dropChuToa.SelectedValue = dropKSV.SelectedValue = "0";

            txtNgayMoPhienHop.Text = txtNgayKT.Text = "";
            txtSoVB.Text = txtNgayKyVB.Text = "";

            dropNguoiKy.SelectedValue = "0";
            txtChucVu.Text = txtGhiChu.Text = "";
        }
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("KQGiaiQuyet_Ds.aspx");
        }

        protected void txtNgayMoPhienHop_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtNgayMoPhienHop.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayMoPhienHop.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtNgayKT.Text = txtNgayMoPhienHop.Text;
            }
            txtNgayKT.Focus();
        }
    }
}
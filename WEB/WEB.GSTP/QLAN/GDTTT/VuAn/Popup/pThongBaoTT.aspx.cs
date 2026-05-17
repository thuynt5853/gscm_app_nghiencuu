using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using BL.GSTP.GDTTT;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pThongBaoTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID==0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (Request["vid"] != null)
                    {
                        LoadThongTinVuAn();
                        LoadDSThongBao();

                        //đổi nhan theo loai an
                        decimal vuanid = Convert.ToDecimal(Request["vid"]);
                        GDTTT_VUAN oVa = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).First() ?? new GDTTT_VUAN();
                        if (oVa.ID > 0)
                        {
                            if (oVa.LOAIAN == 1)
                            {
                                lblTitleBC.Text = "Bị cáo khiếu nại";
                                lblTitleBCDV.Text = "Bi cáo đầu vụ";
                            }
                            else
                            {
                                lblTitleBC.Text = "Nguyên đơn/ Người khởi kiện";
                                lblTitleBCDV.Text = "Bị đơn/ Người  bị kiện";
                            }
                        }

                    }
                }
            }
        }
     

        void LoadThongTinVuAn()
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                
                //---------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                    txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                                    
                //----------------------------------
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);                           
            }
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
        //-----------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                int is_savechange = 0;
                Decimal curr_thongbao_id = Convert.ToDecimal(hddThongBaoID.Value);
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_DON_TRALOI obj = new GDTTT_DON_TRALOI();
                Decimal DonID = 0, ThongBaoID = 0;
                foreach(RepeaterItem item in rptTB.Items)
                {
                    HiddenField hddDonID = (HiddenField)item.FindControl("hddDonID");
                    HiddenField hddThongBaoID = (HiddenField)item.FindControl("hddThongBaoID");
                    DonID = Convert.ToDecimal(hddDonID.Value);
                    ThongBaoID = Convert.ToDecimal(hddThongBaoID.Value);

                    TextBox txtSo = (TextBox)item.FindControl("txtSo");
                    TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                    TextBox txtGhiChu = (TextBox)item.FindControl("txtGhiChu");
                    Literal lttCQChuyenDon = (Literal)item.FindControl("lttCQChuyenDon");

                    if ((!string.IsNullOrEmpty(txtSo.Text.Trim())) || (!string.IsNullOrEmpty(txtNgay.Text.Trim())))
                    {
                        if (ThongBaoID > 0)
                            obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongBaoID).FirstOrDefault();
                        else
                            obj = new GDTTT_DON_TRALOI();
                        obj.DONID = DonID;
                        obj.VUANID = VuAnID;
                        obj.TYPETB = ENUM_LOAITHONGBAO_QH.TBTINHTHE;
                        obj.LOAI = 2;// co quan chuyen don
                        obj.NGUOINHAN = lttCQChuyenDon.Text;
                        obj.SO = txtSo.Text.Trim();
                        obj.NGAY = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        obj.GHICHU = txtGhiChu.Text.Trim();
                        if (ThongBaoID == 0)
                            dt.GDTTT_DON_TRALOI.Add(obj);
                        is_savechange++;
                    }
                }
                if (is_savechange > 0)
                {
                    dt.SaveChanges();
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Cập nhật thành công !";
                }
            }
            catch (Exception ex)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi:" + ex.Message;
            }
        }
                
        //-----------------------------
        void SetNgayCV(TextBox control_so, TextBox control_ngay)
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime ngay = (DateTime)((String.IsNullOrEmpty(control_ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(control_ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GDTTT_DON_TRALOI_GetLastSo(VuAnID, ngay);
            control_so.Text = SoCV + "";
        }

        //------------------------------
        void LoadDSThongBao()
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            try
            {
                GDTTT_DON_TRALOI_BL objBL = new GDTTT_DON_TRALOI_BL();
                DataTable tbl = objBL.GetAllTBTinhThe(VuAnID);
                if (tbl != null && tbl.Rows.Count> 0)
                {
                    rptTB.DataSource = tbl;
                    rptTB.DataBind();
                    rptTB.Visible = true;
                }
                else
                    rptTB.Visible = false;
            }catch(Exception ex) { rptTB.Visible = false; }
        }
        protected void rptTB_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThongbaoID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    try
                    {
                        if (ThongbaoID > 0)
                        {
                            GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongbaoID).Single();
                            if (obj != null)
                                dt.GDTTT_DON_TRALOI.Remove(obj);
                            dt.SaveChanges();

                            LoadDSThongBao();
                            // Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                        }
                    }
                    catch (Exception ex) { }

                    break;
            }
        }
    }
}

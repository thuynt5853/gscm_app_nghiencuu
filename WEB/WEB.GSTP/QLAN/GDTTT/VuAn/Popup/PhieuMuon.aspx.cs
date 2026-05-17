using BL.GSTP;
using DAL.GSTP;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class PhieuMuon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0, CurrUserID=0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal PhongBanID = 0, CurrDonViID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            CurrentYear = DateTime.Now.Year;
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    txtNgayTao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    GetNewSoPhieu();
                    LoadDropToaAn_VKS();
                    hddGroupID.Value = Guid.NewGuid().ToString();
                    LoadDropCanBo();
                    if (Request["item"] != null)
                    {
                        hddListVuAn.Value = Request["item"].ToString().Replace("_", ",");
                        LoadGrid();
                    }
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void GetNewSoPhieu()
        {
            Decimal loaiphieu = Convert.ToDecimal(dropLoai.SelectedValue);
            DateTime NgayTao = (DateTime)((String.IsNullOrEmpty(txtNgayTao.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayTao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, CurrDonViID, PhongBanID);
            txtSoPhieu.Text = SoCV + "";
        }
        protected void txtNgayTao_TextChanged(object sender, EventArgs e)
        {
            GetNewSoPhieu();
        }
        void LoadDropCanBo()
        {
            dropCanBo.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetByPhongBan(PhongBanID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropCanBo.DataSource = tbl;
                dropCanBo.DataValueField = "CanBoID";
                dropCanBo.DataTextField = "TenCanBo";
                dropCanBo.DataBind();
                dropCanBo.Items.Insert(0, new ListItem("Không chọn", "0"));
            }
            else
                dropCanBo.Items.Insert(0, new ListItem("Không chọn", "0"));
        }
     
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            try
            {
                bool retval =  SaveData();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
       
        bool SaveData()
        {
            bool retval = false;
            String Group_DK = hddGroupID.Value + "";
            GDTTT_QUANLYHS obj = new GDTTT_QUANLYHS();
            decimal vuan_id = 0;
            Boolean isupdate = false;
            string list_vuan =  hddListVuAn.Value;
            if (!String.IsNullOrEmpty(list_vuan))
            {
                String[] arr = list_vuan.Split(',');
                DateTime date_temp = new DateTime();
                foreach (String item in arr)
                {
                    vuan_id = (!String.IsNullOrEmpty(item)) ? Convert.ToDecimal(item) : 0;
                    obj = dt.GDTTT_QUANLYHS.Where(x => x.GROUPID == Group_DK && x.VUANID == vuan_id).FirstOrDefault();
                    if (obj != null)
                        isupdate = true;
                    else
                    {
                        isupdate = false;
                        obj = new GDTTT_QUANLYHS();
                        date_temp = (String.IsNullOrEmpty(txtNgayTao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayTao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        obj.NGAYTAO = date_temp;
                    }
                    //------------------------------
                    obj.TOAANMUONHSID = obj.VKSMUONHSID = 0;
                    obj.ISMUONHOSOVKS = Convert.ToDecimal(rdLoaiDV.SelectedValue);
                    if (obj.ISMUONHOSOVKS == 0)
                        obj.TOAANMUONHSID = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
                    else
                        obj.VKSMUONHSID = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
                    //------------------------------
                    obj.LOAI = dropLoai.SelectedValue;
                    obj.VUANID = vuan_id;
                    obj.TRANGTHAI = Convert.ToInt16(dropTrangThai.SelectedValue);
                    obj.SOPHIEU =Convert.ToDecimal  ( txtSoPhieu.Text.Trim());
                    obj.GROUPID = Group_DK;
                    if (dropCanBo.SelectedValue == "0")
                    {
                        obj.CANBOID = 0;
                        obj.TENCANBO = Cls_Comon.FormatTenRieng(txtCanBo.Text.Trim());
                    }
                    else
                    {
                        obj.CANBOID = Convert.ToDecimal(dropCanBo.SelectedValue);
                        obj.TENCANBO = dropCanBo.SelectedItem.Text;
                    }

                    if (!isupdate)
                        dt.GDTTT_QUANLYHS.Add(obj);
                    dt.SaveChanges();
                }
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                return true;
            }
            else
            {
                lbthongbao.Text = "Đề nghị chọn vụ án muốn tạo " + dropLoai.SelectedItem.Text.ToLower();
                return false;
            }
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String  Group_DK = hddGroupID.Value;
            Boolean retval = SaveData();
            //--------------------------
            if (retval)
            {
                String SessionName = "GDTTT_ReportPL".ToUpper();
                GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
                DataTable tbl = objBL.GetByGroupID(Group_DK);
                String ReportName = "Phiếu mượn".ToUpper();
                Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
                Session[SessionName] = tbl;

                String JS = "window.open('/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso&loai=mHS&gID=" + Group_DK + "'"                  
                   + ", '', 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=950, height=500, top=100, left=10')";

                Cls_Comon.CallFunctionJS(this, this.GetType(), JS);
            }
        }
        void ClearForm()
        {
            dropLoai.SelectedIndex  = dropTrangThai.SelectedIndex = dropCanBo.SelectedIndex= 0;
            txtCanBo.Text = txtNgayTao.Text = "";
            lbthongbao.Text = "";
        }

        protected void chkInputCB_CheckedChanged(object sender, EventArgs e)
        {
            if (chkInputCB.Checked)
            {
                dropCanBo.Visible = false;
                //dropCanBo.SelectedIndex = 0;
                txtCanBo.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtCanBo.ClientID);
            }
            else
            {
                dropCanBo.Visible = true;
                txtCanBo.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropCanBo.ClientID);
            }
        }

        //---------------------------------------
        #region Load ds      
        public void LoadGrid()
        {
            string list_vuan = ","+ hddListVuAn.Value + ",";
            List<GDTTT_VUAN> lst = dt.GDTTT_VUAN.Where(x => list_vuan.Contains("," + x.ID + ",")).ToList();
            if (lst != null && lst.Count>0)
            {
                int count_item = 1;
                foreach (GDTTT_VUAN obj in lst)
                {
                    //Gan tam vao cac column nay de hien thi ra ngoai ds
                    obj.SOTOTRINH = count_item.ToString();
                    obj.GHICHU = dt.DM_TOAAN.Where(x => x.ID == (decimal)obj.TOAPHUCTHAMID).FirstOrDefault().MA_TEN;
                    obj.GQD_GHICHU =(String.IsNullOrEmpty(obj.QHPL_DINHNGHIAID+""))? "": dt.GDTTT_DM_QHPL.Where(x => x.ID == (decimal)obj.QHPL_DINHNGHIAID).FirstOrDefault().TENQHPL;
                    count_item++;
                }
                rpt.DataSource = lst;
                rpt.DataBind();
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {               
                case "Xoa":
                    xoa(curr_id);
                    break;
            }
        }
        void xoa(decimal id)
        {
            string list_vuan =hddListVuAn.Value;
            String[] arr = list_vuan.Split('_');
            foreach(String item in arr)
            {
                if (id.ToString() != item)
                    list_vuan += (String.IsNullOrEmpty(list_vuan)) ? item : ("_" + item);
            }
            hddListVuAn.Value = list_vuan;
        }
       
        protected void dropCanBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropCanBo.SelectedValue == "0")
                lblHoTen.Visible = txtCanBo.Visible= lttValidHoTen.Visible = true;            
            else
                lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = false;
        }


        #endregion
        //-------------------------
        protected void rdLoaiDV_SelectedIndexChanged(object sender, EventArgs e)
        {
            string loai = rdLoaiDV.SelectedValue;
            if (loai == "0")
                lblDonVi.Text = "Tòa án";
            else lblDonVi.Text = "Viện kiểm sát";
            LoadDropToaAn_VKS();
        }
        void LoadDropToaAn_VKS()
        {
            dropToaAn_VKS.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            if (rdLoaiDV.SelectedValue == "0")
            {
                DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
                dropToaAn_VKS.DataSource = dtTA;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
            {
                //load ds VKS
                List<DM_VKS> lst = dt.DM_VKS.OrderBy(x => x.ARRTHUTU).ToList();
                dropToaAn_VKS.DataSource = lst;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }
    }
}
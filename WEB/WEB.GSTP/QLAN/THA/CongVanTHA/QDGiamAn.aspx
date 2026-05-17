<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QDGiamAn.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.CongVanTHA.QDGiamAn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <script src="../../../UI/js/Common.js"></script>
    
    <!----------------------------------------------------->
    <asp:HiddenField ID="HddID" runat="server" Value="0" />
    <asp:HiddenField ID="Hddindex" runat="server" Value="1" />
    <asp:HiddenField ID="HddPage" runat="server" Value="20" />

    <!----------------------------------------------------->
    <asp:Panel ID="pn" runat="server">
        <div style="margin-left: 1%; width: 98%; float: left; margin-bottom:250px;">
        <div style="margin: 15px 1%; text-align: center; width: 98%; color: red;">
            <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
        </div>
            
        <div class="boxchung">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
            <h4 class="tleboxchung bg_title_group bg_yellow">Quyết định giảm thời hạn tù</h4>
            <div class="boder" style="padding: 5px 10px;">
                <table class="table1">
                    <tr>
                        <td style="width: 100px;">Số quyết định<span class="batbuoc">(*)</span>
                        </td>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtSoQuyetDinh" runat="server" Width="185px" CssClass="user align_right"></asp:TextBox>
                        </td>

                        <td style="width: 120px">Ngày ra quyết định<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNgayRaQD" runat="server" Width="122px"
                                CssClass="user"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayRaQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayRaQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayRaQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Mức giảm<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNam" runat="server" CssClass="user" Width="30px" MaxLength="4" onkeypress=" return isNumber(event) "></asp:TextBox>
                            Năm
                          &nbsp;
                        <asp:TextBox ID="txtThang" runat="server" CssClass="user" Width="30px" MaxLength="2" onkeypress=" return isNumber(event) "></asp:TextBox>
                            Tháng  
                         <asp:TextBox ID="txtngay" runat="server" CssClass="user" Width="30px" MaxLength="2" onkeypress=" return isNumber(event) "></asp:TextBox>
                            Ngày  
                        </td>
                        <td>Địa điểm<span class="batbuoc">(*)</span>
                        </td>
                        <td>
                            <asp:DropDownList ID="DropTinh" runat="server" Width="130px" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropTinh_SelectedIndexChanged"></asp:DropDownList>
                            &nbsp;
                        <asp:DropDownList ID="DropQuan_huyen" runat="server" Width="130px" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3"></td>


                        <td>(Nơi đang CHHP tu hoặc cư trú)</td>
                    </tr>
                    <tr>

                        <td>Địa chỉ chi tiết</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtDiaChiCT" runat="server" Width="650px" CssClass="user"></asp:TextBox>

                        </td>
                    </tr>


                    <tr>
                        <td>Người ký <span class="batbuoc">(*)</span> </td>
                        <td>
                            <asp:DropDownList ID="DropNguoiKi" runat="server"
                                CssClass="chosen-select" Width="230px" AutoPostBack="true"
                                OnSelectedIndexChanged="DropNguoiKi_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td>Chức vụ</td>
                        <td>
                            <asp:HiddenField ID="hddChucVuID" runat="server" />
                            <asp:TextBox ID="txtChucVu" runat="server" Width="262px" CssClass="user" disabled="disabled"></asp:TextBox>
                        </td>
                    </tr>

                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF"/>
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm file đính kèm"></asp:LinkButton>
                                </td>
                            </tr>
                    <tr>
                        <td colspan="4" style="padding-top: 10px; text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                            <asp:Button ID="cmdResert" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="cmdResert_Click" /></td>
                    </tr>
                </table>



                <div style="padding-top: 10px; text-align: center; width: 95%; float: left; margin-left: 2%; color: red;">
                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                </div>


            </div>
        </div>
        <asp:Panel runat="server" ID="pndata" Visible="false">

            <%-- <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách</h4>--%>
            <div style="float: left; width: 100%;">

                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="6"
                    AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                    <Columns>
                        <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                        <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                Thứ tự
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Container.DataSetIndex + 1 %>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="100px" ItemStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                Quyết định số
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%#Eval("SOQD")%>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra QĐ"
                            HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Center"
                            HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>


                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"
                            HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                Mức giảm
                            </HeaderTemplate>
                            <ItemTemplate>
                                <span><%#Eval("GIAM_NAM") %> năm  <%#Eval("GIAM_THANG")%> tháng  <%#Eval("GIAM_NGAY")%> ngày</span>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                Địa điểm
                            </HeaderTemplate>
                            <ItemTemplate><%#Eval("NoiThiHanhAn") %></ItemTemplate>
                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>File đính kèm</HeaderTemplate>
                                            <ItemTemplate >
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("FILE_ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px"
                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                Thao tác
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                    CommandName="Sua" ForeColor="#0e7eee"
                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                    Text="Xóa" ForeColor="#0e7eee"
                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                    </Columns>
                    <HeaderStyle CssClass="header"></HeaderStyle>
                    <ItemStyle CssClass="chan"></ItemStyle>
                    <PagerStyle Visible="false"></PagerStyle>
                </asp:DataGrid>

            </div>
        </asp:Panel>
    </div>
    </asp:Panel>

        <div style="width: 100%; float: left;">

            <asp:Label runat="server" ID="lbThongbao_top" ForeColor="Red"></asp:Label>
        </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

        function validate() {

            var txtSoQD = document.getElementById('<%=txtSoQuyetDinh.ClientID%>');
            if (!Common_CheckTextBox(txtSoQD, "số quyết định"))
                return false;
            var txtNgayRaQD = document.getElementById('<%=txtNgayRaQD.ClientID%>')
            if (!CheckDateTimeControl(txtNgayRaQD, 'Ngày ra quyết định'))
                return false;
            //---------------------------------
            var ngay = 0, thang = 0, nam = 0;
            var txtNam = document.getElementById('<%=txtNam.ClientID%>');
            if (Common_CheckEmpty(txtNam.value))
                nam = parseInt(txtNam.value);
            var txtThang = document.getElementById('<%=txtThang.ClientID%>');
            if (Common_CheckEmpty(txtThang.value))
                thang = parseInt(txtThang.value);
            var txtngay = document.getElementById('<%=txtngay.ClientID%>');
            if (Common_CheckEmpty(txtngay.value))
                ngay = parseInt(txtngay.value);

            if (ngay == 0 && thang == 0 && nam == 0) {
                alert('Bạn cần chọn mức giảm án cho bị án. Hãy kiểm tra lại');
                txtNam.focus();
                return false;
            }

            //----------Drop------------------
            var DropTinh = document.getElementById('<%=DropTinh.ClientID%>');
            value_changed = DropTinh.options[DropTinh.selectedIndex].value;
            if (value_changed == "") {
                alert('Bạn chưa chọn tỉnh. Hãy kiểm tra lại!');
                DropTinh.focus();
                return false;
            }

            var DropQuan_huyen = document.getElementById('<%=DropQuan_huyen.ClientID%>');
            value_quan_changed = DropQuan_huyen.options[DropQuan_huyen.selectedIndex].value;
            if (value_quan_changed == "0") {
                alert('Bạn chưa chọn quận/huyện. Hãy kiểm tra lại!');
                DropQuan_huyen.focus();
                return false;
            }
         
            var DropNguoiKi = document.getElementById('<%=DropNguoiKi.ClientID%>');
            var value_change = DropNguoiKi.options[DropNguoiKi.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn người ký. Hãy kiểm tra lại!');
                DropNguoiKi.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>

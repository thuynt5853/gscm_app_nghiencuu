<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DsToiDanh.aspx.cs" Inherits="WEB.GSTP.Danhmuc.BoLuat.DsToiDanh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <script src="../../UI/js/Common.js"></script><asp:HiddenField ID="hddType" Value="1" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style>
        #tblSearchDK tr, td{padding-bottom: 5px;}
    </style>
    <div style="float: left; width: 97%;margin-left:1.5%;">
        <h4 class="tleboxchung">Tìm kiếm</h4>
        <div class="boder">
            <table style="width: 100%; margin-top: 25px;"  id="tblSearchDK">
                <tr>
                    <td>Bộ luật</td>
                    <td style="width: 265px"><asp:DropDownList ID="dropBoLuat" runat="server"
                            CssClass="chosen-select" Width="250px"
                            AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td style="width:70px;">Chương</td>
                    <td>
                         <asp:DropDownList ID="dropChuong" runat="server"
                                    CssClass="chosen-select" Width="250px"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropChuong_SelectedIndexChanged">
                                </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Điều</td>
                    <td>
                            <asp:DropDownList ID="dropDieu" runat="server"
                                    CssClass="chosen-select" Width="250px"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropDieu_SelectedIndexChanged">
                                </asp:DropDownList>
                        </td>
                    <td>Khoản</td>
                    <td>
                        <asp:DropDownList ID="dropKhoan" runat="server"
                                    CssClass="chosen-select" Width="250px"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropKhoan_SelectedIndexChanged">
                                </asp:DropDownList>
                    </td>
                </tr>
                <tr><td>Từ khóa</td>
                    <td >                      
                            <span style="float: left;"><asp:TextBox runat="server" ID="txttimkiem" Width="242px" CssClass="user"></asp:TextBox>
                           </span>
                       </td>
                    <td>Trạng thái?</td>
                    <td>
                        <span style="float:left; margin-right:5px;">
                        <asp:DropDownList ID="dropHieuLuc" runat="server" CssClass="chosen-select" >
                            <asp:ListItem Value="2" Text="---Tất cả---" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Không còn hiệu lực"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Còn hiệu lực"></asp:ListItem>
                                
                            </asp:DropDownList>
                             <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"                            
                               Text="cap nhat arr thutu" OnClick="btnUpdate_Click" Visible="false" />
                                <asp:Button ID="cmdUpdateSX" runat="server" CssClass="buttoninput" 
                                    Text="cap nhat arr sapxep"  OnClick="btnUpdateArrSapXep_Click"  Visible="false"/>

                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                        </span><a href="Edit.aspx" class="buttoninput" style="min-width:0px;height: 28px;float: left;line-height: 28px;" >Thêm mới</a>
                      <%--  <asp:Button ID="cmdThemMoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="cmdThemMoi_Click" />--%>
                      
                    </td>
                </tr>
            </table>
        </div>
        <div style="float: left; width: 100%; margin-top: 15px;">
            <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
        </div>
        <asp:Panel runat="server" ID="pndata" Visible="false">
            <div class="phantrang">
                <div class="sobanghi">
                    <asp:Button ID="cmUpdateConfig" runat="server" CssClass="buttoninput"
                            Text="Cập nhật cấu hình" OnClick="cmUpdateConfig_Click" />
                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                </div>
                <div class="sotrang">
                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                        OnClick="lbTBack_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                    <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                        OnClick="lbTNext_Click"></asp:LinkButton>
                </div>
            </div>
            <table class="table2" style="width: 100%;" border="1">
                <tr class="header">
                    <td width="25">
                        <div align="center"><strong>TT</strong></div>
                    </td>
                    <td style="width: 50px;">
                        <div align="center"><strong>Chương</strong></div>
                    </td>
                    <td style='width: 50px'>
                        <div align="center"><strong>Điều</strong></div>
                    </td>
                    <td style='width: 50px;'>
                        <div align="center"><strong>Khoản</strong></div>
                    </td>
                    <td style='width: 50px;'>
                        <div align="center"><strong>Điểm</strong></div>
                    </td>

                    <td>
                        <div align="center"><strong>Tiêu đề</strong></div>
                    </td>
                    <td>
                        <div align="center"><strong>Quan hệ tội danh thống kê</strong></div>
                    </td>
                    <td>
                        <div align="center"><strong>Quan hệ PM Công bố</strong></div>
                    </td>
                     <td style='width: 150px;'>
                        <div align="center"><strong>Mức độ nghiêm trọng</strong></div>
                    </td>
                    <td style="width:80px;">
                        <div align="center"><strong>Thao tác</strong></div>
                    </td>
                </tr>
                <asp:Repeater ID="rpt" runat="server"
                    OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>

                            <td><%# Eval("STT") %></td>
                            <td><%#Eval("Chuong") %></td>
                            <td><%#Eval("Dieu") %></td>
                            <td><%#Eval("Khoan") %></td>
                            <td><%#Eval("Diem") %></td>
                            <td><%#Eval("TenToiDanh") %>
                                </td>
                            <td  style="width: 300px;">
                                <asp:HiddenField ID="hddID" runat="server" Value='<%#Eval("ID") %>' />
                                    <asp:HiddenField ID="hddOldTOIDANHTK_ID" runat="server" Value='<%#Eval("TOIDANHTK_ID") %>'/> 
                                    <asp:DropDownList ID="dropTOIDANHTK" runat="server"
                                       CssClass="chosen-select" Width="400px">
                                    </asp:DropDownList>
                                <asp:Literal ID="ltdropTOIDANHTK" runat="server"></asp:Literal>
                                </td>
                            <td  style="width: 300px;">
                                <asp:HiddenField ID="hddIDCONGBO" runat="server" Value='<%#Eval("ID") %>' />
                                    <asp:HiddenField ID="hddOldTOIDANHCONGBO_ID" runat="server" Value='<%#Eval("CONGBO_CASE_ID") %>'/> 
                                    <asp:DropDownList ID="dropTOIDANHCONGBO" runat="server"
                                       CssClass="chosen-select" Width="400px">
                                    </asp:DropDownList>
                                <asp:Literal ID="ltdropTOIDANHCONGBO" runat="server"></asp:Literal>
                                </td>
                            <td><%#Eval("MucDoNghiemTrong") %>
                                </td>
                            <td align="center" style="width: 55px;">
                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                &nbsp;|&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                              
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
            <div class="phantrang">
                <div class="sobanghi">
                    <asp:HiddenField ID="hdicha" runat="server" />
                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                </div>
                <div class="sotrang">
                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                        OnClick="lbTBack_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                    <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                    <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                        OnClick="lbTNext_Click"></asp:LinkButton>
                </div>
            </div>
        </asp:Panel>
    </div>
      <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>

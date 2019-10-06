<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Swimmming2Win.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
    <h3>contact page.</h3>
    <address>
        Miami University<br />
        501 E High St, Oxford, OH 45056<br />
        <abbr title="Phone">P:</abbr>
        (614)746-1488
    </address>

    <address>
        <strong>Support:</strong>   <a href="mailto:wardnp@miamioh.edu">wardnp@miamioh.edu</a><br />
        <strong>Marketing:</strong> <a href="mailto:wardnp@miamioh.edu">wardnp@miamioh.edu</a>
    </address>
</asp:Content>
